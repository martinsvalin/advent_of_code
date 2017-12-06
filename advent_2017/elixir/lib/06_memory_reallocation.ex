defmodule MemoryReallocation do
  @moduledoc """
  Debugging a routine that reallocates memory.

  Memory banks are balanced by taking all the blocks of one bank and
  allocating them one by one to the following blocks, wrapping around
  to the first bank if it reaches the end. The program chooses the
  bank with the most blocks in and in case of a tie it picks the first
  one.

  1. Detect infinite loops: count cycles until we see a state we've seen.
  2. What is the size of the detected loop?
  """

  @doc """
  Count cycles until we see a state we've seen before.

  ## Examples

      iex> MemoryReallocation.cycles_until_repetition([0, 2, 7, 0])
      5
      iex> MemoryReallocation.cycles_until_repetition([2,4,1,2])
      4
  """
  def cycles_until_repetition(input) do
    {unique_configurations, _} = detect_repetition(input)

    MapSet.size(unique_configurations)
  end


  @doc """
  Give the size of the loop detected

  ## Examples

      iex> MemoryReallocation.size_of_loop([0,2,7,0])
      4
      iex> MemoryReallocation.size_of_loop([2,4,1,2])
      4
  """
  def size_of_loop(input) do
    {_, repeated} = detect_repetition(input)
    cycles_until_repetition(repeated)
  end

  @doc false
  def detect_repetition(mem_banks), do: detect_repetition(mem_banks, MapSet.new)
  def detect_repetition(mem_banks, seen) do
    if MapSet.member?(seen, mem_banks) do
      {seen, mem_banks}
    else
      detect_repetition(reallocate(mem_banks), MapSet.put(seen, mem_banks))
    end
  end

  defp reallocate(mem_banks) do
    {biggest, index} = mem_banks |> Enum.with_index |> Enum.max_by(&elem(&1, 0))
    skipped = Enum.take(mem_banks, index)
    acc = [0 | Enum.reverse(skipped)]

    cycle(Enum.drop(mem_banks, index + 1), biggest, acc)
  end

  defp cycle([], 0, acc), do: Enum.reverse(acc)
  defp cycle([hd | tl], 0, acc), do: cycle(tl, 0, [hd | acc])
  defp cycle([], pot, acc), do: cycle(Enum.reverse(acc), pot, [])
  defp cycle([hd | tl], pot, acc), do: cycle(tl, pot - 1, [hd + 1 | acc])
end