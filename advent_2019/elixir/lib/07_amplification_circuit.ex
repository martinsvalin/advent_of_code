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

  @phase_settings 0..4

  @doc """
  Part 1: What is the highest final signal?
  """
  def part1(input) do
    final_signals =
      Enum.map(permutations(@phase_settings), fn phase_settings ->
        Enum.reduce(phase_settings, 0, fn phase_setting, signal ->
          [{_line, next_signal}] = Intcode.run(input, [phase_setting, signal]).outputs
          next_signal
        end)
      end)

    Enum.max(final_signals)
  end

  def permutations(enum) when not is_list(enum), do: permutations(Enum.to_list(enum))
  def permutations([]), do: [[]]

  def permutations(list) when is_list(list) do
    for head <- list, tail <- permutations(list -- [head]), do: [head | tail]
  end
end
