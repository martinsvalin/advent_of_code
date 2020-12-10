defmodule AdapterArray do
  def full_array_differences(numbers) do
    sorted = sort_and_pad(numbers)

    sorted
    |> Enum.zip(tl(sorted))
    |> Enum.map(fn {a, b} -> a - b end)
    |> Enum.frequencies()
  end

  def sort_and_pad(numbers) do
    sorted = Enum.sort([0 | numbers], :desc)

    [hd(sorted) + 3 | sorted]
  end

  def count_combinations(numbers) do
    sorted = sort_and_pad(numbers)

    count_paths(sorted, %{hd(sorted) => 1})
  end

  defp count_paths([a, b, c, 0 | _], mem)
       when is_map_key(mem, a) and
              is_map_key(mem, b) and
              is_map_key(mem, c) do
    # normal exit case, we're within range of the charging outlet
    sum_paths([a, b, c], 0, mem)
  end

  defp count_paths([a, b, 0 | _], mem)
       when is_map_key(mem, a) and
              is_map_key(mem, b) do
    # this should only happen for single-item input
    sum_paths([a, b], 0, mem)
  end

  defp count_paths([a, 0 | _], mem)
       when is_map_key(mem, a) do
    # this should only happen on empty input
    mem[a]
  end

  defp count_paths([a, b, c, d | tail], mem)
       when is_map_key(mem, a) and
              is_map_key(mem, b) and
              is_map_key(mem, c) and
              not is_map_key(mem, d) do
    # this is the work-horse. Things are memoized, and we just steam ahead
    count_paths(
      [b, c, d | tail],
      Map.put(mem, d, sum_paths([a, b, c], d, mem))
    )
  end

  defp count_paths([a, b, c | tail], mem)
       when is_map_key(mem, a) and
              is_map_key(mem, b) and
              not is_map_key(mem, c) do
    # building up memory
    count_paths(
      [a, b, c | tail],
      Map.put(mem, c, sum_paths([a, b], c, mem))
    )
  end

  defp count_paths([a, b | tail], mem)
       when is_map_key(mem, a) and
              not is_map_key(mem, b) do
    # building up memory
    count_paths(
      [a, b | tail],
      Map.put(mem, b, mem[a])
    )
  end

  defp sum_paths(list, comparison, mem) do
    list
    |> Enum.filter(&(&1 <= comparison + 3))
    |> Enum.map(&mem[&1])
    |> Enum.sum()
  end
end
