defmodule SpiralMemory do
  @moduledoc """
  Spiral memory is essentially a linked list laid out in a spiral
  """

  @doc """
  Gives the Manhattan distance from the start after following the spiral a number of steps

  ## Examples

      iex> distance_from_start(1)
      0
      iex> distance_from_start(12)
      3
      iex> distance_from_start(23)
      2
      iex> distance_from_start(1024)
      31
  """
  def distance_from_start(limit) do
    [{x,y}] = Spiral.stream
      |> Stream.drop(limit-1)
      |> Enum.take(1)
    abs(x) + abs(y)
  end

  @doc """
  Give values for spiral positions as a sum of values at previous positions

  As we spiral outwards, set the value of each cell as the sum of values of
  its neighbors including diagonals. The starting value is 1. This is returned
  as a map %{coordinate => value}. The enumeration halts after a value that's
  greater than a given limit.

        147  142  133  122   59
        304    5    4    2   57
        330   10    1    1   54
        351   11   23   25   26
        362  747  806  -->  ...


  ## Examples

      iex> sum_of_neighbor_spiral(100)
      %{
                                       {1, 2}  => 122, {2, 2}  => 59,
        {-1, 1}  => 5,  {0, 1}  => 4,  {1, 1}  => 2,   {2, 1}  => 57,
        {-1, 0}  => 10, {0, 0}  => 1,  {1, 0}  => 1,   {2, 0}  => 54,
        {-1, -1} => 11, {0, -1} => 23, {1, -1} => 25,  {2, -1} => 26
      }
  """
  def sum_of_neighbor_spiral(limit) do
    Enum.reduce_while(Spiral.stream, %{}, fn coord, map ->
      case neighbors(map, coord) |> Enum.sum |> max(1) do
        sum when sum >= limit -> {:halt, Map.put(map, coord, sum)}
        sum                   -> {:cont, Map.put(map, coord, sum)}
      end
    end)
  end

  defp neighbors(map, {x,y}) do
    for xx <- x-1..x+1,
        yy <- y-1..y+1,
        map[{xx, yy}]
    do
      map[{xx, yy}]
    end
  end
end

defmodule Spiral do
  @moduledoc """
  Generate cartesian coordinates in a spiral

  The first cell is in the center, going left, up, right, down etc:

      17  16  15  14  13
      18  5   4   3   12
      19  6   1   2   11
      20  7   8   9   10
      21  22  23 --> ...
  """

  @doc """
  Generate spiral coordinates as a stream, starting from {0,0}
  """
  def stream do
    Stream.unfold({MapSet.new, {0,0}, :south}, &unfold_spiral/1)
  end

  defp unfold_spiral({set, coordinate, direction}) do
    new_set = MapSet.put(set, coordinate)
    {next_coordinate, next_direction} = next(new_set, coordinate, direction)

    {coordinate, {new_set, next_coordinate, next_direction}}
  end

  @rotate %{south: :east, east: :north, north: :west, west: :south}

  defp next(set, coordinate, direction) do
    if MapSet.member?(set, left(coordinate, direction)) do
      {forward(coordinate, direction), direction}
    else
      {left(coordinate, direction), @rotate[direction]}
    end
  end

  defp forward(coordinate, direction), do: apply(__MODULE__, direction, [coordinate])
  defp left(coordinate, direction), do: apply(__MODULE__, @rotate[direction], [coordinate])

  @doc false
  def south({x,y}), do: {x, y-1}
  @doc false
  def north({x,y}), do: {x, y+1}
  @doc false
  def east({x,y}),  do: {x+1, y}
  @doc false
  def west({x,y}),  do: {x-1, y}
end
