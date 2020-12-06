defmodule CustomCustoms do
  def sum_group_answers(input, strategy \\ &MapSet.union/2) do
    collect_group_answers(input)
    |> Enum.map(&Enum.reduce(&1, strategy))
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  def collect_group_answers(input, groups \\ [[MapSet.new()]])

  def collect_group_answers(<<char>> <> rest, [[current_set | sets] | groups])
      when char in ?a..?z do
    collect_group_answers(rest, [[MapSet.put(current_set, char) | sets] | groups])
  end

  def collect_group_answers("\n\n" <> rest, groups) do
    collect_group_answers(rest, [[MapSet.new()] | groups])
  end

  def collect_group_answers("\n" <> rest, [current_group | groups]) do
    collect_group_answers(rest, [[MapSet.new() | current_group] | groups])
  end

  def collect_group_answers("", groups) do
    groups |> Enum.map(&Enum.reverse/1) |> Enum.reverse()
  end
end
