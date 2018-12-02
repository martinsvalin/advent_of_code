defmodule ChronalCalibration do
  @moduledoc """
  December 1 - Chronal Calibration

  The problem can be found at https://adventofcode.com/2018/day/1
  1. Starting from zero, what is the resulting frequency, i.e. the sum?
  2. What is the first frequency your device reaches twice?
  """

  @input_file Path.join([__DIR__, "..", "inputs", "01.txt"])
  def part1(file \\ @input_file) do
    file
    |> File.read!()
    |> parse()
    |> sum()
  end

  def part2(file \\ @input_file) do
    file
    |> File.read!()
    |> parse()
    |> first_repeat()
  end

  def part2stream(file \\ @input_file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn change, {prev, all_seen} ->
      new = prev + change

      case Enum.member?(all_seen, new) do
        true -> {:halt, new}
        false -> {:cont, {new, MapSet.put(all_seen, new)}}
      end
    end)
  end

  defp parse(string) do
    string
    |> String.trim_trailing()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Give the resulting frequency after all the changes have been applied.

  Input is a list of integer numbers.

  ## Examples

      iex> sum([1, 1, 1])
      3

      iex> sum([1, 1, -2])
      0

      iex> sum([-1, -2, -3])
      -6
  """
  def sum(input) when is_list(input) do
    Enum.sum(input)
  end

  @doc """
  Find the first repeated frequency when applying changes.

  Input is a list of integer numbers.

  ## Examples

      iex> first_repeat([1, -1])
      0

      iex> first_repeat([3, 3, 4, -2, -4])
      10

      iex> first_repeat([-6, 3, 8, 5, -6])
      5

      iex> first_repeat([+7, +7, -2, -7, -4])
      14
  """
  def first_repeat(input) when is_list(input) do
    first_repeat(input, 0, MapSet.new([0]), input)
  end

  defp first_repeat([], current, sums, original) do
    first_repeat(original, current, sums, original)
  end

  defp first_repeat([h | t], current, sums, original) do
    new_sum = h + current

    if MapSet.member?(sums, new_sum) do
      new_sum
    else
      first_repeat(t, new_sum, MapSet.put(sums, new_sum), original)
    end
  end
end
