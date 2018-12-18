defmodule ChronalCoordinates do
  @moduledoc """
  December 6 - Chronal Coordinates

  The problem can be found at https://adventofcode.com/2018/day/6
  1. What is the size of the largest area that isn't infinite?
  2. What is the size of the region where all distances are less than 10_000?
  """

  @type coordinate() :: {non_neg_integer(), non_neg_integer()}
  @type accumulator() :: %{
          destinations: [coordinate()],
          edges: {Range.t(), Range.t()},
          bounding_box: [coordinate()],
          groups: map(),
          finite: map()
        }

  @input_file Path.join([__DIR__, "../inputs/06.txt"])
  @spec part1() :: non_neg_integer()
  def part1(), do: part1(File.read!(@input_file))

  @spec part1(binary()) :: non_neg_integer()
  def part1(input) do
    input
    |> parse_destinations()
    |> bounding_box()
    |> group_areas()
    |> discard_infinite_areas()
    |> biggest_area()
    |> area_size()
  end

  @spec parse_destinations(binary()) :: accumulator()
  def parse_destinations(input) do
    destinations =
      Regex.scan(~r/(\d+), ?(\d+)/, input, capture: :all_but_first)
      |> Enum.reduce(MapSet.new(), fn [x, y], destinations ->
        MapSet.put(destinations, {String.to_integer(x), String.to_integer(y)})
      end)

    %{destinations: destinations}
  end

  @spec bounding_box(accumulator()) :: accumulator()
  def bounding_box(acc) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(acc.destinations, fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(acc.destinations, fn {_, y} -> y end)
    box = for x <- min_x..max_x, y <- min_y..max_y, do: {x, y}

    acc
    |> Map.put(:bounding_box, box)
    |> Map.put(:edges, {min_x..max_x, min_y..max_y})
  end

  @spec group_areas(accumulator()) :: accumulator()
  def group_areas(%{bounding_box: box} = acc) do
    groups =
      Enum.group_by(box, fn xy ->
        acc.destinations |> Enum.to_list() |> closest(xy)
      end)

    Map.put(acc, :groups, groups)
  end

  @spec closest([coordinate()], coordinate()) :: coordinate() | :equal
  def closest([h | destinations], xy) do
    closest(destinations, xy, %{coord: h, min: distance(h, xy)})
  end

  @spec closest([coordinate()], coordinate(), map()) :: coordinate() | :equal
  def closest([], _xy, %{equal: true}), do: :equal
  def closest([], _xy, closest), do: closest.coord

  def closest([h | destinations], xy, %{min: min} = closest) do
    case distance(h, xy) do
      ^min ->
        closest(destinations, xy, Map.put(closest, :equal, true))

      distance when distance < min ->
        closest(destinations, xy, %{coord: h, min: distance})

      _ ->
        closest(destinations, xy, closest)
    end
  end

  @spec distance(coordinate(), coordinate()) :: non_neg_integer()
  defp distance({x, y}, {a, b}), do: abs(x - a) + abs(y - b)

  @spec print(accumulator()) :: accumulator()
  def print(%{groups: groups} = acc) do
    IO.puts("")
    zipped = Enum.zip(groups, ?a..?z)

    zipped
    |> Enum.flat_map(fn
      {{:equal, coords}, _} ->
        Enum.map(coords, &{&1, "."})

      {{d, coords}, letter} ->
        Enum.map(coords, fn
          ^d -> {d, IO.ANSI.bright() <> String.upcase(<<letter>>) <> IO.ANSI.normal()}
          c -> {c, <<letter>>}
        end)
    end)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.group_by(fn {{_, y}, _} -> y end, fn {_, mark} -> mark end)
    |> Enum.sort()
    |> Enum.map(fn {_, letters} -> Enum.join(letters) end)
    |> Enum.join("\n")
    |> IO.puts()

    labels = for {{d, _}, letter} <- zipped, d != :equal, do: <<letter>> <> " = #{inspect(d)}"

    Enum.join(labels, ", ")
    |> IO.puts()

    acc
  end

  def print(acc), do: IO.inspect(acc)

  @spec discard_infinite_areas(accumulator()) :: accumulator()
  def discard_infinite_areas(%{edges: {min_x..max_x, min_y..max_y}} = acc) do
    finite =
      Enum.reject(acc.groups, fn {_destination, area} ->
        Enum.any?(area, fn {x, y} -> x in [min_x, max_x] || y in [min_y, max_y] end)
      end)

    Map.put(acc, :finite, Map.new(finite))
  end

  @spec biggest_area(accumulator()) :: {coordinate(), [coordinate()]}
  def biggest_area(%{finite: finite}) do
    Enum.max_by(finite, fn {_, area} -> Enum.count(area) end)
  end

  @spec area_size({coordinate(), [coordinate()]}) :: non_neg_integer()
  def area_size({_destination, area}), do: Enum.count(area)
end
