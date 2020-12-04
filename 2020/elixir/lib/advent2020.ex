defmodule Advent2020 do
  def input(day) do
    File.read!("input/#{pad_day(day)}")
  end

  def lines(day) do
    input(day) |> String.split("\n", trim: true)
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
