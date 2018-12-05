defmodule ReposeRecord do
  @moduledoc """
  December 4 - Repose Record

  The problem can be found at https://adventofcode.com/2018/day/4
  1. What is product of the ID and minute you chose?
  2. ...
  """

  @input_file Path.join([__DIR__, "..", "inputs", "04.txt"])
  def part1(), do: part1(File.read!(@input_file))

  def part1(string) do
    %{id: id, minute: minute} =
      string
      |> parse()
      |> sleepiest_guard()
      |> sleepiest_minute()

    id * minute
  end

  def part2(), do: part2(File.read!(@input_file))

  def part2(string) do
    %{id: id, minute: minute} =
      string
      |> parse()
      |> Enum.map(&sleepiest_minute/1)
      |> Enum.max_by(& &1.count)

    id * minute
  end

  @doc """
  Parse sleeping patterns

  Input is given as a log. Sleep and awake events belong to the last guard to
  go on duty.It may look like this:

      [1518-11-01 00:00] Guard #10 begins shift
      [1518-11-01 00:05] falls asleep
      [1518-11-01 00:25] wakes up
      [1518-11-01 00:30] falls asleep
      [1518-11-01 00:55] wakes up
      [1518-11-01 23:58] Guard #99 begins shift
      [1518-11-02 00:40] falls asleep
      [1518-11-02 00:50] wakes up
      [1518-11-03 00:05] Guard #10 begins shift
      [1518-11-03 00:24] falls asleep
      [1518-11-03 00:29] wakes up
      [1518-11-04 00:02] Guard #99 begins shift
      [1518-11-04 00:36] falls asleep
      [1518-11-04 00:46] wakes up
      [1518-11-05 00:03] Guard #99 begins shift
      [1518-11-05 00:45] falls asleep
      [1518-11-05 00:55] wakes up

  ## Examples

      iex> # @example_input is as listed in the description
      iex> parse(@example_input)
      %{10 => [24..28, 30..54, 5..24], 99 => [45..54, 36..45, 40..49]}
  """
  def parse(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.sort()
    |> Enum.map(&parse_line/1)
    |> collect_sleep_ranges()
  end

  defp parse_line(line) do
    pattern = ~r/^.*:(\d\d)\] (.*)$/
    [_minute, _action] = Regex.run(pattern, line, capture: :all_but_first)
  end

  defp collect_sleep_ranges(lines, current \\ %{}, acc \\ %{})
  defp collect_sleep_ranges([], _, acc), do: acc

  defp collect_sleep_ranges([[minute, "falls asleep"] | lines], current, acc) do
    collect_sleep_ranges(
      lines,
      Map.put(current, :start, String.to_integer(minute)),
      acc
    )
  end

  defp collect_sleep_ranges([[minute, "wakes up"] | lines], current, acc) do
    range = current.start..(String.to_integer(minute) - 1)

    collect_sleep_ranges(
      lines,
      Map.take(current, [:guard]),
      Map.update(acc, current.guard, [range], &[range | &1])
    )
  end

  defp collect_sleep_ranges([[_, guard_on_duty] | lines], _, acc) do
    ["#" <> guard_id] = Regex.run(~r/#\d+/, guard_on_duty)

    collect_sleep_ranges(lines, %{guard: String.to_integer(guard_id)}, acc)
  end

  @doc """
  Picks the guard that sleeps the most minutes

  ## Examples

      iex> guards = %{10 => [24..28, 30..54, 5..24], 99 => [45..54, 36..45, 40..49]}
      iex> sleepiest_guard(guards)
      {10, [24..28, 30..54, 5..24]}
  """
  def sleepiest_guard(guards) do
    Enum.max_by(guards, fn {_id, ranges} ->
      Enum.map(ranges, fn first..last -> last - first end) |> Enum.sum()
    end)
  end

  @doc """
  Picks the minute the guard sleeps the most

  ## Examples

      iex> sleepiest_minute({10, [24..28, 30..54, 5..24]})
      %{id: 10, minute: 24, count: 2}
  """
  def sleepiest_minute({id, sleep_ranges}) do
    {winner_minute, count} =
      Enum.reduce(0..59, {0, 0}, fn minute, {best_minute, best_count} ->
        count = Enum.count(sleep_ranges, &(minute in &1))

        (count > best_count && {minute, count}) || {best_minute, best_count}
      end)

    %{id: id, minute: winner_minute, count: count}
  end
end
