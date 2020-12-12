defmodule Advent2020 do
  def input(day) do
    File.read!("input/#{pad_day(day)}")
  end

  def lines(day) when is_integer(day) do
    input(day) |> lines()
  end

  def lines(string) do
    String.split(string, "\n", trim: true)
  end

  def numbers(day) do
    lines(day) |> Enum.map(&String.to_integer/1)
  end

  defp pad_day(day) do
    day
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end
end
