defmodule FractalArt do
  @moduledoc """
  Dec 21 - Fractal Art

  We refine a piece of art in an iterative process starting from the 3x3 grid:

      .#.
      ..#
      ###

  This grid is said to have a size of 3.

  For grid even grid sizes, divide into 2x2 grids, and transform to 3x3 with the
  given rules. Otherwise divide up in 3x3 grids, and transform them to 4x4 with
  the given rules.

  Rules represent grids in a compact one-line form, where rows are separated with
  a slash. The starting grid corresponds to `.#./..#/###`. An example rule is
  `.#./..#/### => #..#/..../..../#..#`.
  You may have to rotate or flip the input to find the corresponding rule. Output
  is not rotated.

  1. How many cells are on after 5 iterations?
  """

  @doc """
  Generate art by applying pattern rules for a given number of iterations
  """
  def generate_art(rules, iterations) do
    rules = rules |> parse() |> prefill_variations()

    glider()
    |> generate_art(rules, iterations)
    |> Enum.join("\n")
  end

  def generate_art(grid, _, 0), do: grid

  def generate_art(grid, rules, iterations) do
    generate_art(enhance(grid, rules), rules, iterations - 1)
  end

  def enhance(grid, rules) when length(grid) in [2,3], do: Map.get(rules, grid)
  def enhance(grid, rules) when length(grid) > 3 do
    grid |> split_grid() |> Enum.map(& enhance(&1, rules)) |> join_grid()
  end

  def split_grid(grid) do
    half = length(grid) |> div(2)

    [
      Enum.take(grid, half) |> Enum.map(& Enum.take(&1, half)),
      Enum.take(grid, half) |> Enum.map(& Enum.drop(&1, half)),
      Enum.drop(grid, half) |> Enum.map(& Enum.take(&1, half)),
      Enum.drop(grid, half) |> Enum.map(& Enum.drop(&1, half))
    ]
  end

  def join_grid([left_up, right_up, left_down, right_down]) do
    up = Enum.zip(left_up, right_up) |> Enum.map(fn {left, right} -> left ++ right end)
    down = Enum.zip(left_down, right_down) |> Enum.map(fn {left, right} -> left ++ right end)

    up ++ down
  end

  @doc false
  def glider() do
    [
      '.#.',
      '..#',
      '###'
    ]
  end

  @regex ~r/(.*) => (.*)/m

  @doc """
  Parse pattern rules to a map

  ## Examples

      iex> parse("#./.. => ##./#../...\n.#./..#/### => #..#/..../..../#..#\n")
      %{
        ['#.', '..'] => ['##.', '#..', '...'],
        ['.#.', '..#', '###'] => ['#..#', '....', '....', '#..#']
      }
  """
  def parse(string) do
    Regex.scan(@regex, string)
    |> Map.new(fn [_, from, to] ->
         {parse_pattern(from), parse_pattern(to)}
       end)
  end

  defp parse_pattern(pattern) do
    pattern |> String.split("/") |> Enum.map(&to_charlist/1)
  end

  @doc false
  def prefill_variations(rules) do
    Enum.reduce(Map.keys(rules), rules, fn key, map ->
      Enum.reduce(Matrix.variations(key), map, &Map.put(&2, &1, map[key]))
    end)
  end
end
