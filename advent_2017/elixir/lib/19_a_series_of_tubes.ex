defmodule ASeriesOfTubes do
  @moduledoc """
  Dec 19 - A Series of Tubes

  We have a diagram of a path with letters along the path. We start at the top.
  A example diagram looks like this:

          |          
          |  +--+    
          A  |  C    
      F---|----E|--+ 
          |  |  |  D 
          +B-+  +--+ 


  1. What are the letters we encounter along the path, in order?
  2. How many steps do we need to walk?
  """

  def waypoints(input) do
    input
    |> parse_to_map()
    |> follow_path()
  end

  defp follow_path(map) do
    {start, _} =
      Enum.find(map, fn
        {{0, _}, :straight} -> true
        _ -> false
      end)

    follow_path(start, map, :south, [], 0)
  end

  defp follow_path(pos, map, dir, letters, steps) do
    case map[pos] do
      nil -> {:done, letters |> Enum.reverse() |> Enum.join(), steps}
      :corner -> turn(pos, map, dir, letters, steps)
      :straight -> follow_path(next(pos, dir), map, dir, letters, steps + 1)
      letter -> follow_path(next(pos, dir), map, dir, [letter | letters], steps + 1)
    end
  end

  defp next({row, col}, :north), do: {row - 1, col}
  defp next({row, col}, :south), do: {row + 1, col}
  defp next({row, col}, :west), do: {row, col - 1}
  defp next({row, col}, :east), do: {row, col + 1}

  defp turn(pos, map, dir, letters, steps) when dir in [:north, :south] do
    cond do
      map[next(pos, :west)] -> follow_path(next(pos, :west), map, :west, letters, steps + 1)
      map[next(pos, :east)] -> follow_path(next(pos, :east), map, :east, letters, steps + 1)
    end
  end

  defp turn(pos, map, dir, letters, steps) when dir in [:west, :east] do
    cond do
      map[next(pos, :north)] -> follow_path(next(pos, :north), map, :north, letters, steps + 1)
      map[next(pos, :south)] -> follow_path(next(pos, :south), map, :south, letters, steps + 1)
    end
  end

  defp parse_to_map(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, &parse_line/2)
  end

  defp parse_line({line, row}, acc) do
    line
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.reduce(acc, fn
         {" ", _}, acc -> acc
         {"|", col}, acc -> Map.put(acc, {row, col}, :straight)
         {"-", col}, acc -> Map.put(acc, {row, col}, :straight)
         {"+", col}, acc -> Map.put(acc, {row, col}, :corner)
         {letter, col}, acc -> Map.put(acc, {row, col}, letter)
       end)
  end
end
