defmodule CorruptionCheckpoint do
  @moduledoc """
  December 2 - Corruption Checkpoint

  The problem can be found at http://adventofcode.com/2017/day/2
  1. What is the checksum of the spreadsheet, as sum of line max-min difference
  2. Sum division of the only two numbers that evenly divide on each line
  """

  @doc """
  The checksum is the sum of max-min differences per row
  """
  def checksum(spreadsheet) do
    spreadsheet
    |> to_rows_of_numbers
    |> Enum.map(&max_min_difference/1)
    |> Enum.sum()
  end

  @doc """
  Sum division of the only two numbers that evenly divide on each line
  """
  def divisible(spreadsheet) do
    spreadsheet
    |> to_rows_of_numbers
    |> Enum.map(&only_division/1)
    |> Enum.sum()
  end

  defp to_rows_of_numbers(spreadsheet) do
    spreadsheet
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line |> String.split() |> Enum.map(&String.to_integer/1)
    end)
  end

  defp max_min_difference([]), do: 0

  defp max_min_difference([hd | tl]) do
    {max, min} = Enum.reduce(tl, {hd, hd}, fn n, {max, min} -> {max(max, n), min(min, n)} end)
    max - min
  end

  defp only_division([]), do: 0

  defp only_division([hd | tl]) do
    find_division(hd, tl) || only_division(tl)
  end

  defp find_division(_, []), do: false
  defp find_division(n, [hd | _]) when rem(n, hd) == 0, do: div(n, hd)
  defp find_division(n, [hd | _]) when rem(hd, n) == 0, do: div(hd, n)
  defp find_division(n, [_ | tl]), do: find_division(n, tl)
end
