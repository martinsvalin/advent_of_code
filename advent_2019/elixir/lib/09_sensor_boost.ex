defmodule SensorBoost do
  @moduledoc """
  # Day 9: Sensor Boost

  https://adventofcode.com/2019/day/9

  Introducing relative mode (2) into our Intcode computer.
  Also introducing opcode 9, relative base adjust.
  """

  @doc """
  Part 1: What BOOST keycode does the input program produce in test mode?

  Run in test mode by giving it a `1` as input.
  """
  def part1(input \\ Util.numbers(9)) do
    Intcode.run(input, [1]).outputs |> hd
  end

  @doc """
  Part 1: What are the coordinates of the distress signal?

  Run in sensor boost mode by giving it a `2` as input.
  """
  def part2(input \\ Util.numbers(9)) do
    Intcode.run(input, [2]).outputs |> hd
  end
end
