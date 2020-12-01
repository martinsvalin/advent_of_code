defmodule Advent2020 do
  def lines(day) do
    day =
      Integer.to_string(day)
      |> String.pad_leading(2, "0")

    File.read!("input/#{day}")
    |> String.split("\n", trim: true)
  end

  def numbers(day) do
    lines(day) |> Enum.map(&String.to_integer/1)
  end
end
