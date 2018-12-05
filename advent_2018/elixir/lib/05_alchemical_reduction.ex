defmodule AlchemicalReductions do
  @moduledoc """
  December 4 - Alchemical Reductions

  The problem can be found at https://adventofcode.com/2018/day/5
  1. How many letters remain after reduction?
  2. How long is the shortest polymer after removing a letter and reducing?
  """

  @polarity ?a - ?A

  @input_file Path.join([__DIR__, "..", "inputs", "05.txt"])
  def part1(), do: part1(File.read!(@input_file))

  def part1(polymer) do
    polymer
    |> reduce()
  end

  def part2(), do: part2(File.read!(@input_file))

  def part2(polymer) do
    polymer
    |> variations()
    |> Stream.map(&reduce/1)
    |> Stream.map(&length/1)
    |> Enum.min()
  end

  @doc """
  Reduce polymer by repeatedly removing units of opposite polarity

  ## Examples

      iex> reduce('aA')
      ''

      iex> reduce('abBA')
      ''

      iex> reduce('abAB')
      'abAB'

      iex> reduce('aabAAB')
      'aabAAB'

      iex> reduce('dabAcCaCBAcCcaDA')
      'dabCBAcaDA'
  """
  def reduce(string) when is_binary(string), do: to_charlist(string) |> reduce()
  def reduce([head | tail]), do: reduce([head], tail)

  def reduce([left | front], [right | back])
      when left in [right + @polarity, right - @polarity] do
    reduce(front, back)
  end

  def reduce(front, [right | back]), do: reduce([right | front], back)
  def reduce(front, []), do: Enum.reverse(front)

  @doc """
  Stream of variations on the input, with one letter removed

  ## Examples

      iex> all_variations = variations("abBA")
      iex> Enum.count(all_variations)
      26
      iex> all_variations |> Enum.to_list() |> Enum.take(2)
      ["bB", "aA"]
  """
  @stop_chars [?Z + 1, ?z + 1]
  def variations(polymer) do
    Stream.unfold('Aa', fn
      @stop_chars ->
        nil

      [upper, lower] = letters ->
        {String.replace(polymer, ~r/[#{letters}]/, ""), [upper + 1, lower + 1]}
    end)
  end
end
