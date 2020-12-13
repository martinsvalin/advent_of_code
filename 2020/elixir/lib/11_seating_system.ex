defmodule SeatingSystem do
  def stabilize(input, rules \\ &simple_rules/2) do
    input |> parse() |> tick_until_stable(rules)
  end

  defp tick_until_stable(seats, rules, ticks \\ 0)
  defp tick_until_stable(seats, _, ticks) when ticks > 1000, do: {:safety_limit_reached, seats}

  defp tick_until_stable(seats, rules, ticks) do
    case tick(seats, rules) do
      ^seats -> seats
      new -> tick_until_stable(new, rules, ticks + 1)
    end
  end

  def tick({seats, max}, rules \\ &simple_rules/2) do
    {Map.new(seats, fn seat -> rules.(seat, {seats, max}) end), max}
  end

  def simple_rules({position, :empty}, {seats, _}) do
    if occupied_neighbors(position, seats) == [] do
      {position, :occupied}
    else
      {position, :empty}
    end
  end

  def simple_rules({position, :occupied}, {seats, _}) do
    if occupied_neighbors(position, seats) |> length() >= 4 do
      {position, :empty}
    else
      {position, :occupied}
    end
  end

  defp occupied_neighbors({x, y}, seats) do
    for dx <- -1..1,
        dy <- -1..1,
        {dx, dy} != {0, 0},
        seat = seats[{x + dx, y + dy}],
        seat == :occupied,
        do: seat
  end

  def line_of_sight_rules({position, :empty}, {seats, max}) do
    if occupied_visible(position, seats, max) == 0 do
      {position, :occupied}
    else
      {position, :empty}
    end
  end

  def line_of_sight_rules({position, :occupied}, {seats, max}) do
    if occupied_visible(position, seats, max) >= 5 do
      {position, :empty}
    else
      {position, :occupied}
    end
  end

  defp occupied_visible(position, seats, max) do
    [
      left(position),
      up_left(position),
      up(position),
      up_right(position, max),
      right(position, max),
      down_right(position, max),
      down(position, max),
      down_left(position, max)
    ]
    |> Enum.map(fn directions -> Enum.find_value(directions, &Map.get(seats, &1)) end)
    |> Enum.count(&(&1 == :occupied))
  end

  def left(position, acc \\ [])
  def left({0, _}, acc), do: Enum.reverse(acc)
  def left({x, y}, acc), do: left({x - 1, y}, [{x - 1, y} | acc])

  def up_left(position, acc \\ [])
  def up_left({0, _}, acc), do: Enum.reverse(acc)
  def up_left({_, 0}, acc), do: Enum.reverse(acc)
  def up_left({x, y}, acc), do: up_left({x - 1, y - 1}, [{x - 1, y - 1} | acc])

  def up(position, acc \\ [])
  def up({_, 0}, acc), do: Enum.reverse(acc)
  def up({x, y}, acc), do: up({x, y - 1}, [{x, y - 1} | acc])

  def up_right(position, max, acc \\ [])
  def up_right({max_x, _}, {max_x, _}, acc), do: Enum.reverse(acc)
  def up_right({_, 0}, _, acc), do: Enum.reverse(acc)
  def up_right({x, y}, max, acc), do: up_right({x + 1, y - 1}, max, [{x + 1, y - 1} | acc])

  def right(position, max, acc \\ [])
  def right({max_x, _}, {max_x, _}, acc), do: Enum.reverse(acc)
  def right({x, y}, max, acc), do: right({x + 1, y}, max, [{x + 1, y} | acc])

  def down_right(position, max, acc \\ [])
  def down_right({max_x, _}, {max_x, _}, acc), do: Enum.reverse(acc)
  def down_right({_, max_y}, {_, max_y}, acc), do: Enum.reverse(acc)
  def down_right({x, y}, max, acc), do: down_right({x + 1, y + 1}, max, [{x + 1, y + 1} | acc])

  def down(position, max, acc \\ [])
  def down({_, max_y}, {_, max_y}, acc), do: Enum.reverse(acc)
  def down({x, y}, max, acc), do: down({x, y + 1}, max, [{x, y + 1} | acc])

  def down_left(position, max, acc \\ [])
  def down_left({0, _}, _, acc), do: Enum.reverse(acc)
  def down_left({_, max_y}, {_, max_y}, acc), do: Enum.reverse(acc)
  def down_left({x, y}, max, acc), do: down_left({x - 1, y + 1}, max, [{x - 1, y + 1} | acc])

  def parse(string) when is_binary(string), do: string |> Advent2020.lines() |> parse()

  def parse([first | _] = lines) do
    seats =
      for {line, y} <- Enum.with_index(lines),
          {char, x} <- Enum.with_index(to_charlist(line)),
          char in 'L#',
          into: Map.new() do
        seat =
          case char do
            ?L -> :empty
            ?# -> :occupied
          end

        {{x, y}, seat}
      end

    {seats, {byte_size(first), length(lines)}}
  end

  def to_string({seats, {max_x, max_y}}) do
    lines =
      for y <- 0..(max_y - 1) do
        for x <- 0..(max_x - 1) do
          case Map.get(seats, {x, y}, :floor) do
            :empty -> "L"
            :occupied -> "#"
            :floor -> "."
          end
        end
      end

    Enum.join(lines, "\n") <> "\n"
  end
end
