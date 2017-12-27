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

  1. How many pixels are on after 5 iterations?
  """

  @doc """
  Count how many pixels are on (#) with given rules and number of iterations
  """
  def count_on_pixels(input, iterations) do
    generate_art(input, iterations) |> to_charlist |> Enum.count(&(&1 == ?#))
  end

  @doc """
  Generate art by applying pattern rules for a given number of iterations
  """
  def generate_art(input, iterations) do
    rules = input |> parse() |> prefill_variations()

    glider()
    |> generate_art(rules, iterations)
    |> Enum.join("\n")
  end

  defp generate_art(grid, _, 0), do: grid

  defp generate_art(grid, rules, iterations) do
    generate_art(enhance(grid, rules), rules, iterations - 1)
  end

  @doc false
  def enhance(grid, rules) when length(grid) in [2, 3] do
    Map.get(rules, grid)
  end

  def enhance(grid, rules) when length(grid) > 3 do
    grid
    |> split_grid()
    |> Enum.map(fn row -> Enum.map(row, &enhance(&1, rules)) end)
    |> join_grid()
  end

  @doc false
  def split_grid(grid) when rem(length(grid), 2) == 0, do: split_grid(grid, 2)
  def split_grid(grid) when rem(length(grid), 3) == 0, do: split_grid(grid, 3)

  @doc false
  def split_grid(grid, chunk_size) do
    grid
    |> Enum.chunk_every(chunk_size)
    |> Enum.map(fn chunk ->
         chunk
         |> Enum.map(&Enum.chunk_every(&1, chunk_size))
         |> List.zip()
         |> Enum.map(&Tuple.to_list/1)
       end)
  end

  @doc false
  def join_grid(grids) do
    grids
    |> Enum.map(&zip_row_grids/1)
    |> join_rows()
  end

  defp zip_row_grids(row_grids) do
    row_grids
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.concat/1)
  end

  defp join_rows(row_chunks) do
    Enum.reduce(row_chunks, [], fn rows, acc ->
      Enum.reduce(rows, acc, fn row, a -> [row | a] end)
    end)
    |> Enum.reverse()
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
