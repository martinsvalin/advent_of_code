defmodule DiskDefragmentation do
  @moduledoc """
  Day 14 - Disk Defragmentation

  Help out defragging the disk. Our input represents the current state of the disk,
  which is a 128x128 grid of bits.

  Use KnotHash to produce 128 hashes from your input (suffix with -0 through -127).
  Each knot hash is a row in the grid, where each of the 32 characters represent 4 bits.
  Bits represent squares that are used (1) or free (0).

  Regions are adjacent used squares (not diagonally).

  1. How many squares in the grid are used?
  2. How many regions are in the grid?
  """

  @doc """
  Count used squares from the grid state given by the string
  """
  def count_used(input) do
    input
    |> used()
    |> Enum.count()
  end

  @doc """
  Count connected regions of used squares
  """
  def count_regions(input) do
    input
    |> used()
    |> Enum.reduce([], &build_regions/2)
    |> Enum.count()
  end

  @doc """
  A list of coordinates for used squares in the grid corresponding to the input string
  """
  @spec used(String.t()) :: [[0 | 1]]
  def used(input) do
    for row <- 0..127, hash = KnotHash.real_hash("#{input}-#{row}") do
      hash
      |> hash_to_bits()
      |> Enum.with_index()
      |> Enum.filter(fn {bit, _} -> bit == 1 end)
      |> Enum.map(fn {_bit, col} -> {row, col} end)
    end
    |> List.flatten()
  end

  defp build_regions(coord, regions) do
    {connected, rest} =
      [MapSet.new([coord]) | regions]
      |> Enum.split_with(fn region ->
        Enum.any?(adjacent(coord), &MapSet.member?(region, &1))
      end)

    [Enum.reduce(connected, &MapSet.union/2) | rest]
  end

  defp adjacent({x, y}) do
    [
      {x, y},
      {x, y - 1},
      {x, y + 1},
      {x - 1, y},
      {x + 1, y}
    ]
  end

  defp hash_to_bits(hash) do
    hash
    |> String.codepoints()
    |> Enum.flat_map(&hexdigit_to_bits/1)
  end

  defp hexdigit_to_bits(hexdigit) do
    hexdigit
    |> String.to_integer(16)
    |> Integer.digits(2)
    |> pad_to_four()
  end

  defp pad_to_four(list) when length(list) < 4, do: pad_to_four([0 | list])
  defp pad_to_four(list), do: list
end
