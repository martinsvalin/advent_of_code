defmodule Advent2020Test do
  use ExUnit.Case
  doctest Advent2020

  describe "lines/1" do
    test "lists the lines for that day's input" do
      assert Advent2020.lines(0) == ["1", "2", "3", "4", "5"]
    end
  end

  describe "numbers/1" do
    test "lists lines as numbers for that day's input" do
      assert Advent2020.numbers(0) == [1, 2, 3, 4, 5]
    end
  end
end
