defmodule InventoryManagementSystem do
  @moduledoc """
  December 2 - Inventory Management System

  The problem can be found at https://adventofcode.com/2018/day/2
  1. What is the checksum for the list of boxes?
  2. What letters are common between the two correct box IDs?
  """

  @input_file Path.join([__DIR__, "..", "inputs", "02.txt"])
  def part1(file \\ @input_file) do
    file
    |> parse()
    |> checksum()
  end

  def part2(file \\ @input_file) do
    file
    |> parse()
    |> find_similar()
    |> letters_in_common()
  end

  defp parse(path) do
    path |> File.read!() |> String.split("\n", trim: true)
  end

  @doc """
  Checksum for a list of box IDs.

  The checksum is the product of number of boxes where the same letter occurs
  exactly two times by the number where a letter occurs exactly three times.

  ## Examples

      iex> checksum(["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"])
      12
  """
  def checksum(input) when is_list(input) do
    input
    |> Enum.map(&letter_histogram/1)
    |> count_pairs_and_triplets()
    |> multiply()
  end

  defp letter_histogram(string) when is_binary(string) do
    letter_histogram(String.to_charlist(string))
  end

  defp letter_histogram(letters) when is_list(letters) do
    Enum.reduce(letters, %{}, fn letter, histogram ->
      Map.update(histogram, letter, 1, &(&1 + 1))
    end)
  end

  defp count_pairs_and_triplets(histograms) do
    Enum.reduce(histograms, {0, 0}, fn hist, {pairs, triplets} ->
      pairs = pairs + ((2 in Map.values(hist) && 1) || 0)
      triplets = triplets + ((3 in Map.values(hist) && 1) || 0)
      {pairs, triplets}
    end)
  end

  defp multiply({a, b}), do: a * b

  @doc """
  Find a pair of boxes with similar ID strings

  Similarity is defined as having only a single letter differ when compared in order.

  ## Examples

      iex> find_similar(["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"])
      {"fghij", "fguij"}
  """
  def find_similar([]), do: raise(ArgumentError, "could not find similar box IDs")

  def find_similar([h | t]) do
    case Enum.find(t, &correct_boxes?(&1, h)) do
      nil -> find_similar(t)
      found -> {h, found}
    end
  end

  defp correct_boxes?(a, b) when byte_size(a) == byte_size(b) do
    byte_size(letters_in_common({a, b})) == byte_size(a) - 1
  end

  @doc """
  Letters in common, comparing letters at the same position

  Only defined for equal length strings.

  ## Examples

      iex> letters_in_common({"abcde", "axcye"})
      "ace"

      iex> letters_in_common({"fghij", "fguij"})
      "fgij"
  """
  def letters_in_common({a, b}) do
    letters_in_common(to_charlist(a), to_charlist(b), [])
  end

  def letters_in_common([], [], acc) do
    acc |> Enum.reverse() |> to_string
  end

  def letters_in_common([h | a], [h | b], acc) do
    letters_in_common(a, b, [h | acc])
  end

  def letters_in_common([_ | a], [_ | b], acc) do
    letters_in_common(a, b, acc)
  end
end
