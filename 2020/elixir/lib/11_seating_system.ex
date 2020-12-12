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

  def tick(seats, rules \\ &simple_rules/2) do
    Map.new(seats, fn seat -> rules.(seat, seats) end)
  end

  def simple_rules({position, :empty}, seats) do
    if occupied_neighbors(position, seats) == [] do
      {position, :occupied}
    else
      {position, :empty}
    end
  end

  def simple_rules({position, :occupied}, seats) do
    if occupied_neighbors(position, seats) |> length() >= 4 do
      {position, :empty}
    else
      {position, :occupied}
    end
  end

  def line_of_sight_rules(seat, seats), do: simple_rules(seat, seats)

  defp occupied_neighbors({x, y}, seats) do
    for dx <- -1..1,
        dy <- -1..1,
        {dx, dy} != {0, 0},
        seat = seats[{x + dx, y + dy}],
        seat == :occupied,
        do: seat
  end

  def parse(string) when is_binary(string), do: string |> Advent2020.lines() |> parse()

  def parse(lines) do
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
  end

  def to_string(seats) do
    positions = Map.keys(seats)
    max_x = positions |> Enum.max_by(&elem(&1, 0)) |> elem(0)
    max_y = positions |> Enum.max_by(&elem(&1, 1)) |> elem(1)

    lines =
      for y <- 0..max_y do
        for x <- 0..max_x do
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
