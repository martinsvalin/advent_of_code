defmodule CrossedWires do
  @moduledoc """
  # Day 3: Crossed Wires

  https://adventofcode.com/2019/day/3

  Two wires are connected to a central point. Our input has two lines with
  directions and steps to trace each wire's path, like "R10,U5,L1" meaning
  "go right 10 steps, up 5 steps, left 1 step".

  Part 1: What is the distance of the closest crossing to the central port?
  Part 2: What is the crossing with the shortest combined path?
  """
  @type direction() :: :right | :left | :up | :down
  @type coord() :: {integer(), integer()}

  @doc "Manhattan distance of closest crossing to origo"
  @spec part2([String.t()]) :: pos_integer()
  def part1([line1, line2]) do
    crossings(path(line1), path(line2))
    |> Enum.map(&manhattan_distance/1)
    |> Enum.min()
  end

  defp manhattan_distance({x, y}), do: abs(x) + abs(y)

  @doc "Shortest combined path to a crossing"
  @spec part2([String.t()]) :: pos_integer()
  def part2([line1, line2]) do
    path1 = path(line1)
    path2 = path(line2)

    crossings(path1, path2)
    |> Enum.map(fn xy ->
      Enum.find_index(path1, &(&1 == xy)) + Enum.find_index(path2, &(&1 == xy))
    end)
    |> Enum.min()
  end

  @doc "List of coordinates where two paths cross"
  @spec crossings([coord()], [coord()]) :: [coord()]
  def crossings(path_a, path_b) do
    MapSet.intersection(MapSet.new(path_a), MapSet.new(path_b))
    |> MapSet.delete({0, 0})
    |> Enum.to_list()
  end

  @doc """
  Turns instructions into a list of coordinates along the path

  ## Examples

      iex> path("U1,R2")
      [{0, 0}, {0, 1}, {1, 1}, {2, 1}]
  """
  @spec path([String.t()]) :: [{coord()}]
  def path(line) do
    line |> parse() |> path([{0, 0}])
  end

  def path([{direction, steps} | instructions], path) do
    path(instructions, apply(__MODULE__, direction, [steps, path]))
  end

  def path([], path), do: Enum.reverse(path)

  @doc "Prepends steps to the right, in reverse order"
  def right(steps, [{x, y} | _] = path) do
    Enum.map(steps..1, fn step -> {x + step, y} end) ++ path
  end

  @doc "Prepends steps to the left, in reverse order"
  def left(steps, [{x, y} | _] = path) do
    Enum.map(steps..1, fn step -> {x - step, y} end) ++ path
  end

  @doc "Prepends steps up, in reverse order"
  def up(steps, [{x, y} | _] = path) do
    Enum.map(steps..1, fn step -> {x, y + step} end) ++ path
  end

  @doc "Prepends steps down, in reverse order"
  def down(steps, [{x, y} | _] = path) do
    Enum.map(steps..1, fn step -> {x, y - step} end) ++ path
  end

  @doc "Parses instructions as given in the input into directions and steps"
  @spec parse(String.t()) :: [{direction(), pos_integer()}]
  def parse(line) do
    line
    |> String.split(",", trim: true)
    |> Enum.map(fn str ->
      case str do
        "R" <> n -> {:right, String.to_integer(n)}
        "L" <> n -> {:left, String.to_integer(n)}
        "U" <> n -> {:up, String.to_integer(n)}
        "D" <> n -> {:down, String.to_integer(n)}
      end
    end)
  end
end
