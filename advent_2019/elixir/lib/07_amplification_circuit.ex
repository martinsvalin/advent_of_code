defmodule AmplificationCircuit do
  @moduledoc """
  # Day 7: Amplification Circuit

  https://adventofcode.com/2019/day/7

  Five circuits are to be connected serially. Each will run an Intcode program
  (our input) with two inputs: the first is the phase setting, and the second is
  the incoming signal.

  The phase setting for each circuit is a number 0..4, where each number is used
  once. The incoming signal is the output of the previous circuit. The first
  circuit starts with 0.
  """

  @doc """
  Part 1: What is the highest final signal?
  """
  def part1(input), do: best_signal(input, 0..4)

  @doc """
  Part 2: What is the highest signal from a feedback loop?
  """
  def part2(input), do: best_signal(input, 5..9)

  def best_signal(input, phases) do
    phases
    |> permutations()
    |> Enum.map(&loop(input, &1, 0))
    |> Enum.max()
  end

  def loop(input, phases, signal, states \\ %{})

  def loop(_input, [], signal, _states), do: signal

  def loop(input, [phase | phases], in_signal, states) do
    case(run(Map.get(states, phase, input), phase, in_signal)) do
      {:waiting, %Intcode{outputs: [signal | _]} = state} ->
        loop(input, phases ++ [phase], signal, Map.put(states, phase, state))

      %Intcode{outputs: [signal | _]} ->
        loop(input, phases, signal, states)
    end
  end

  def permutations(enum) when not is_list(enum), do: permutations(Enum.to_list(enum))
  def permutations([]), do: [[]]

  def permutations(list) when is_list(list) do
    for head <- list, tail <- permutations(list -- [head]), do: [head | tail]
  end

  defp run(list, phase, signal) when is_list(list) do
    Intcode.run(list, [phase, signal])
  end

  defp run(%Intcode{} = state, _phase, signal) do
    state |> Intcode.input(signal) |> Intcode.run()
  end
end
