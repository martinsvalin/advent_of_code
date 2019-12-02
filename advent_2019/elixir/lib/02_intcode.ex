defmodule Intcode do
  @moduledoc """
  # Day 2: 1202 Program Alarm

  https://adventofcode.com/2019/day/2

  Intcode is represented as a list of integers, for example 1,0,0,3,99.
  The first number is an operation, 1, 2 or 99.

  Operation 1 means we add two operands and store the result.
  Operation 2 means we mutliply two operands and store the result.
  Operation 99 means we exit the program.

  When adding or multiplying, operands are read from positions given by the
  following two numbers, and the result is stored, overwriting what's at the
  position given by the third number. After storing the result, the program
  advances 4 positions.
  """

  @doc """
  # Part 1: What is stored at position 0 after the program exits?

  Before running the program for part 1, replace position 1 with 12, and
  position 2 with 2.
  """
  def part1(code) do
    code |> replace_noun_and_verb(12, 2) |> run()
  end

  def replace_noun_and_verb(code, noun, verb) do
    code |> List.replace_at(1, noun) |> List.replace_at(2, verb)
  end

  @answer 19_690_720
  @doc """
  # Part 2: What should noun and verb be replaced with to produce 19_690_720?

  Positions 1 and 2 are called the noun and verb respectively. They will each be
  in the range 0..99 inclusive.

  Note: we have alternative implementations of running Intcode programs:
  run/1 and run2/1 respectively. As part2 runs the program many many times, it's
  an excellent opportunity to profile the two. It turns out the map-based run2/1
  outperforms the list-based run/1 by about a factor of 3.
  """
  def part2(code) do
    pairs = for noun <- 0..99, verb <- 0..99, do: {noun, verb}

    {noun, verb} =
      Enum.find(pairs, fn {noun, verb} ->
        code |> replace_noun_and_verb(noun, verb) |> run2() |> Map.get(0) == @answer
      end)

    noun * 100 + verb
  end

  @doc """
  Runs an Intcode program until it exits, and returns the values at each position.

  ## Examples

      iex> Intcode.run([1,0,0,3,99])
      [1,0,0,2,99]
  """
  @spec run([non_neg_integer()]) :: [non_neg_integer()]
  def run(code, position \\ 0) do
    case Enum.drop(code, position) do
      [1, lhs, rhs, dst | _] ->
        sum = Enum.at(code, lhs) + Enum.at(code, rhs)
        run(List.replace_at(code, dst, sum), position + 4)

      [2, lhs, rhs, dst | _] ->
        product = Enum.at(code, lhs) * Enum.at(code, rhs)
        run(List.replace_at(code, dst, product), position + 4)

      [99 | _] ->
        code

      _ ->
        raise ArgumentError, message: "invalid program"
    end
  end

  @doc "Alternate take on run/1, implemented with a map"
  @spec run([non_neg_integer()] | map()) :: map()
  def run2(code, index \\ 0)

  def run2(code, _) when is_list(code) do
    run2(for {value, i} <- Enum.with_index(code), into: %{}, do: {i, value})
  end

  def run2(code, index) do
    case code[index] do
      1 ->
        sum = code[code[index + 1]] + code[code[index + 2]]
        run2(Map.put(code, code[index + 3], sum), index + 4)

      2 ->
        product = code[code[index + 1]] * code[code[index + 2]]
        run2(Map.put(code, code[index + 3], product), index + 4)

      99 ->
        code

      _ ->
        raise ArgumentError, message: "invalid program"
    end
  end
end
