defmodule ConwayCubes do
  def run(input, ticks, dimensions \\ 3) do
    start_cubes = parse(input)

    Enum.reduce(1..ticks, start_cubes, fn _, cubes ->
      tick(cubes, dimensions)
    end)
  end

  def tick(cubes, dimensions) do
    still_active = cubes |> survivors(dimensions)

    activated =
      cubes
      |> inactive_neighbours(dimensions)
      |> activate(cubes, dimensions)

    MapSet.union(still_active, activated)
  end

  def survivors(cubes, dimensions) do
    for cube <- cubes, survives?(cubes, cube, dimensions), into: MapSet.new(), do: cube
  end

  def survives?(cubes, cube, dimensions) do
    MapSet.size(MapSet.intersection(cubes, neighbours(cube, dimensions))) in 2..3
  end

  def neighbours({cube_x, cube_y, cube_z, cube_w}, 3) do
    for x <- -1..1,
        y <- -1..1,
        z <- -1..1,
        {cube_x + x, cube_y + y, cube_z + z, cube_w} != {cube_x, cube_y, cube_z, cube_w},
        into: MapSet.new(),
        do: {cube_x + x, cube_y + y, cube_z + z, cube_w}
  end

  def neighbours({cube_x, cube_y, cube_z, cube_w}, 4) do
    for x <- -1..1,
        y <- -1..1,
        z <- -1..1,
        w <- -1..1,
        {cube_x + x, cube_y + y, cube_z + z, cube_w + w} != {cube_x, cube_y, cube_z, cube_w},
        into: MapSet.new(),
        do: {cube_x + x, cube_y + y, cube_z + z, cube_w + w}
  end

  def inactive_neighbours(cubes, dimensions) do
    Enum.reduce(cubes, MapSet.new(), fn cube, inactive ->
      MapSet.difference(neighbours(cube, dimensions), cubes) |> MapSet.union(inactive)
    end)
  end

  def activate(inactive, active, dimensions) do
    for cube <- inactive,
        neighbours = neighbours(cube, dimensions),
        MapSet.size(MapSet.intersection(neighbours, active)) == 3,
        into: MapSet.new(),
        do: cube
  end

  ## Parsing and printing

  def parse(input, coordinate \\ {0, 0, 0, 0}, out \\ MapSet.new())

  def parse("", _, out), do: out

  def parse("." <> input, {x, y, z, w}, out), do: parse(input, {x + 1, y, z, w}, out)

  def parse("#" <> input, {x, y, z, w}, out) do
    parse(input, {x + 1, y, z, w}, MapSet.put(out, {x, y, z, w}))
  end

  def parse("\n" <> input, {_x, y, z, w}, out), do: parse(input, {0, y + 1, z, w}, out)

  def to_string(cubes, z, w \\ 0) do
    {{min_x, min_y, _, _}, {max_x, max_y, _, _}} = minmax(cubes)
    plane = Enum.filter(cubes, &match?({_, _, ^z, ^w}, &1)) |> MapSet.new()

    lines =
      for y <- min_y..max_y do
        for x <- min_x..max_x do
          if {x, y, z, w} in plane, do: ?#, else: ?.
        end
      end

    Enum.join(lines, "\n") <> "\n"
  end

  defp minmax(cubes) when is_map(cubes), do: minmax(Enum.to_list(cubes))
  defp minmax([]), do: :error
  defp minmax([head | tail]), do: minmax(tail, {head, head})

  defp minmax([], minmax), do: minmax

  defp minmax([{x, y, z, w} | tail], {{min_x, min_y, min_z, min_w}, {max_x, max_y, max_z, max_w}}) do
    minmax(
      tail,
      {{min(x, min_x), min(y, min_y), min(z, min_z), min(w, min_w)},
       {max(x, max_x), max(y, max_y), max(z, max_z), max(w, max_w)}}
    )
  end
end
