defmodule TobogganTrajectory do
  def count_trees(lines, trajectory \\ {3, 1}) do
    tree_map = lines |> parse

    coordinates_on_trajectory(trajectory, length(lines))
    |> Enum.count(fn
      {x, y} -> Map.get(tree_map, y) |> Enum.at(x) == ?#
    end)
  end

  def multiply_tree_counts_for_trajectories(lines, trajectories) do
    trajectories
    |> Enum.reduce(1, fn
      trajectory, product -> product * count_trees(lines, trajectory)
    end)
  end

  def parse(lines) when is_list(lines) do
    lines
    |> Enum.with_index()
    |> Map.new(fn {line, number} -> {number, line |> to_charlist() |> Stream.cycle()} end)
  end

  def coordinates_on_trajectory({dx, dy}, limit) do
    Stream.unfold({0, 0}, fn
      {_, y} when y >= limit -> nil
      {x, y} -> {{x, y}, {x + dx, y + dy}}
    end)
  end
end
