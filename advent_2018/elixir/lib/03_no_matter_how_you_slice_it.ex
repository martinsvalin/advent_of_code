defmodule NoMatterHowYouSliceIt do
  @moduledoc """
  December 3 - No Matter How You Slice It

  The problem can be found at https://adventofcode.com/2018/day/3
  1. How many square inches of fabric are within two or more claims?
  2. What is the ID of the only claim that doesn't overlap?
  """

  @input_file Path.join([__DIR__, "..", "inputs", "03.txt"])
  def part1(), do: part1(File.read!(@input_file))

  def part1(string) do
    string
    |> parse()
    |> to_claim_sets()
    |> overlapping()
    |> Enum.count()
  end

  def part2(), do: part2(File.read!(@input_file))

  def part2(string) do
    claim_sets =
      string
      |> parse()
      |> to_claim_sets()

    {id, _set} = find_intact_claim(claim_sets, overlapping(claim_sets))
    id
  end

  @doc """
  Parse input into a list of X and Y ranges

  Input is a string with lines like: #id @ x_offset,y_offset: x_size,y_size

  ## Examples

      iex> parse("#1 @ 1,3: 4x4\\n#2 @ 3,1: 4x4\\n#3 @ 5,5: 2x2")
      [{"1", 1..4, 3..6}, {"2", 3..6, 1..4}, {"3", 5..6, 5..6}]
  """
  def parse(input) do
    pattern = ~r/^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/m

    Regex.scan(pattern, input, capture: :all_but_first)
    |> Enum.map(fn [id | numbers] ->
      [x_off, y_off, x_size, y_size] = Enum.map(numbers, &String.to_integer/1)
      x_range = x_off..(x_off + x_size - 1)
      y_range = y_off..(y_off + y_size - 1)
      {id, x_range, y_range}
    end)
  end

  def to_claim_sets(list) do
    Map.new(list, fn {id, x_range, y_range} ->
      set = for x <- x_range, y <- y_range, do: {x, y}, into: MapSet.new()
      {id, set}
    end)
  end

  @doc """
  Apply claims to the fabric, returning claimed and overlapping areas

  Input is a list of claims. Each claim is a tuple of X and Y ranges.

  ## Examples

      iex> claims = to_claim_sets([{"1", 1..4, 3..6}, {"2", 3..6, 1..4}])
      iex> overlapping = overlapping(claims)
      iex> Enum.count(overlapping)
      4
  """
  def overlapping(claims) do
    acc = {_claimed = MapSet.new(), _overlapping = MapSet.new()}

    {_, overlapping} =
      Enum.reduce(claims, acc, fn {_id, claim_set}, {claimed, overlapping} ->
        overlap = MapSet.intersection(claimed, claim_set)
        {MapSet.union(claimed, claim_set), MapSet.union(overlapping, overlap)}
      end)

    overlapping
  end

  def find_intact_claim(claim_sets, overlapping) do
    Enum.find(claim_sets, fn {_id, set} -> MapSet.disjoint?(overlapping, set) end)
  end
end
