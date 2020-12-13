defmodule RainRisk do
  def distance({x, y, _}), do: distance({x, y})
  def distance({x, y}), do: abs(x) + abs(y)

  def navigate_ship(instructions, position \\ {0, 0, :east})
  def navigate_ship([], position), do: position

  def navigate_ship([<<instruction>> <> amount | instructions], {_, _, direction} = position) do
    new_position =
      case instruction do
        ?E -> move(position, :east, to_i(amount))
        ?N -> move(position, :north, to_i(amount))
        ?W -> move(position, :west, to_i(amount))
        ?S -> move(position, :south, to_i(amount))
        ?F -> move(position, direction, to_i(amount))
        ?L -> turn(position, :left, to_i(amount))
        ?R -> turn(position, :right, to_i(amount))
      end

    navigate_ship(instructions, new_position)
  end

  def navigate_by_waypoint(instructions, position \\ {0, 0}, waypoint \\ {10, 1})
  def navigate_by_waypoint([], position, _), do: position

  def navigate_by_waypoint([<<instruction>> <> amount | instructions], position, waypoint) do
    {new_position, new_waypoint} =
      case instruction do
        ?E -> {position, move(waypoint, :east, to_i(amount))}
        ?N -> {position, move(waypoint, :north, to_i(amount))}
        ?W -> {position, move(waypoint, :west, to_i(amount))}
        ?S -> {position, move(waypoint, :south, to_i(amount))}
        ?F -> {move_by_waypoint(position, waypoint, to_i(amount)), waypoint}
        ?L -> {position, rotate(waypoint, rem(to_i(amount), 360))}
        ?R -> {position, rotate(waypoint, 360 - rem(to_i(amount), 360))}
      end

    navigate_by_waypoint(instructions, new_position, new_waypoint)
  end

  def move_by_waypoint({ship_x, ship_y}, {waypoint_x, waypoint_y}, amount) do
    {ship_x + waypoint_x * amount, ship_y + waypoint_y * amount}
  end

  def rotate({x, y}, 0), do: {x, y}
  def rotate({x, y}, 90), do: {-y, x}
  def rotate({x, y}, 180), do: {-x, -y}
  def rotate({x, y}, 270), do: {y, -x}
  def rotate({x, y}, 360), do: {x, y}

  def move({x, y, facing}, direction, amount) do
    {new_x, new_y} = move({x, y}, direction, amount)
    {new_x, new_y, facing}
  end

  def move({x, y}, direction, amount) do
    case direction do
      :east -> {x + amount, y}
      :north -> {x, y + amount}
      :west -> {x - amount, y}
      :south -> {x, y - amount}
    end
  end

  def turn({x, y, facing}, :left, amount) do
    case {facing, rem(amount, 360)} do
      {:east, 0} -> {x, y, :east}
      {:east, 90} -> {x, y, :north}
      {:east, 180} -> {x, y, :west}
      {:east, 270} -> {x, y, :south}
      {:north, 0} -> {x, y, :north}
      {:north, 90} -> {x, y, :west}
      {:north, 180} -> {x, y, :south}
      {:north, 270} -> {x, y, :east}
      {:west, 0} -> {x, y, :west}
      {:west, 90} -> {x, y, :south}
      {:west, 180} -> {x, y, :east}
      {:west, 270} -> {x, y, :north}
      {:south, 0} -> {x, y, :south}
      {:south, 90} -> {x, y, :east}
      {:south, 180} -> {x, y, :north}
      {:south, 270} -> {x, y, :west}
    end
  end

  def turn({x, y, facing}, :right, amount) do
    case {facing, rem(amount, 360)} do
      {:east, 0} -> {x, y, :east}
      {:east, 90} -> {x, y, :south}
      {:east, 180} -> {x, y, :west}
      {:east, 270} -> {x, y, :north}
      {:north, 0} -> {x, y, :north}
      {:north, 90} -> {x, y, :east}
      {:north, 180} -> {x, y, :south}
      {:north, 270} -> {x, y, :west}
      {:west, 0} -> {x, y, :west}
      {:west, 90} -> {x, y, :north}
      {:west, 180} -> {x, y, :east}
      {:west, 270} -> {x, y, :south}
      {:south, 0} -> {x, y, :south}
      {:south, 90} -> {x, y, :west}
      {:south, 180} -> {x, y, :north}
      {:south, 270} -> {x, y, :east}
    end
  end

  defp to_i(string), do: String.to_integer(string)
end
