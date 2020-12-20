defmodule ConwayCubes do
  def run(input, ticks) do
    start_cubes = parse(input)

    Enum.reduce(1..ticks, start_cubes, fn _, cubes ->
      tick(cubes)
    end)
  end

  def tick(cubes) do
    still_active = cubes |> survivors()
    activated = cubes |> inactive_neighbours() |> activate(cubes)
    MapSet.union(still_active, activated)
  end

  def survivors(cubes) do
    for cube <- cubes, survives?(cubes, cube), into: MapSet.new(), do: cube
  end

  def survives?(cubes, cube) do
    MapSet.size(MapSet.intersection(cubes, neighbours(cube))) in 2..3
  end

  def neighbours({cube_x, cube_y, cube_z}) do
    for x <- -1..1,
        y <- -1..1,
        z <- -1..1,
        {cube_x + x, cube_y + y, cube_z + z} != {cube_x, cube_y, cube_z},
        into: MapSet.new(),
        do: {cube_x + x, cube_y + y, cube_z + z}
  end

  def inactive_neighbours(cubes) do
    Enum.reduce(cubes, MapSet.new(), fn cube, inactive ->
      MapSet.difference(neighbours(cube), cubes) |> MapSet.union(inactive)
    end)
  end

  def activate(inactive, active) do
    for cube <- inactive,
        neighbours = neighbours(cube),
        MapSet.size(MapSet.intersection(neighbours, active)) == 3,
        into: MapSet.new(),
        do: cube
  end

  ## Parsing and printing

  def parse(input, coordinate \\ {0, 0, 0}, out \\ MapSet.new())

  def parse("", _, out), do: out

  def parse("." <> input, {x, y, z}, out), do: parse(input, {x + 1, y, z}, out)

  def parse("#" <> input, {x, y, z}, out) do
    parse(input, {x + 1, y, z}, MapSet.put(out, {x, y, z}))
  end

  def parse("\n" <> input, {_x, y, z}, out), do: parse(input, {0, y + 1, z}, out)

  def to_string(cubes, z) do
    {{min_x, min_y, _}, {max_x, max_y, _}} = minmax(cubes)
    plane = Enum.filter(cubes, &match?({_, _, ^z}, &1)) |> MapSet.new()

    lines =
      for y <- min_y..max_y do
        for x <- min_x..max_x do
          if {x, y, z} in plane, do: ?#, else: ?.
        end
      end

    Enum.join(lines, "\n") <> "\n"
  end

  defp minmax(cubes) when is_map(cubes), do: minmax(Enum.to_list(cubes))
  defp minmax([]), do: :error
  defp minmax([head | tail]), do: minmax(tail, {head, head})

  defp minmax([], minmax), do: minmax

  defp minmax([{x, y, z} | tail], {{min_x, min_y, min_z}, {max_x, max_y, max_z}}) do
    minmax(
      tail,
      {{min(x, min_x), min(y, min_y), min(z, min_z)},
       {max(x, max_x), max(y, max_y), max(z, max_z)}}
    )
  end
end
