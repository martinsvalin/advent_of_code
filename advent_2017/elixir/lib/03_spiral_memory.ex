# 37 36 35 34 33 32 31
# 38 17 16 15 14 13 30
# 39 18  5  4  3 12 29
# 40 19  6  1  2 11 28
# 41 20  7  8  9 10 27
# 42 21 22 23 24 25 26
# 43 44 45 46 47 48 49


defmodule SpiralMemory do
  @next_direction %{right: :up, up: :left, left: :down, down: :right}

  def spiral(limit), do: make_spiral(%{}, {0,0}, 1, :down, limit)

  defp make_spiral(spiral, position, value, _direction, limit) when limit <= value do
    Map.put_new(spiral, position, value)
  end
  defp make_spiral(spiral, position, value, direction, limit) do
    {new_position, new_direction} = turn_or_forward(spiral, position, direction)
    new_spiral = Map.put_new(spiral, position, value)

    make_spiral(
      new_spiral, 
      new_position, 
      new_value(new_spiral, new_position), 
      new_direction, 
      limit
    )
  end

  defp new_value(spiral, position) do
    Map.get(spiral, up(left(position)), 0)   + Map.get(spiral, up(position), 0)   + Map.get(spiral, up(right(position)), 0) +
    Map.get(spiral, left(position), 0)                                            + Map.get(spiral, right(position), 0) +
    Map.get(spiral, down(left(position)), 0) + Map.get(spiral, down(position), 0) + Map.get(spiral, down(right(position)), 0)
  end

  defp turn_or_forward(spiral, position, direction) do
    case spiral[turn(position, direction)] do
      nil -> {turn(position, direction), @next_direction[direction]}
      _   -> {forward(position, direction), direction}
    end
  end

  defp forward(position, direction), do: apply(__MODULE__, direction, [position])
  defp turn(position, direction), do: apply(__MODULE__, @next_direction[direction], [position])

  def right({x,y}), do: {x + 1, y}
  def left({x,y}),  do: {x - 1, y}
  def up({x,y}),    do: {x, y + 1}
  def down({x,y}),  do: {x, y - 1}
end
