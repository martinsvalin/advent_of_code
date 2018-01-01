defmodule SantaVisitsTest do
  use ExUnit.Case
  import SantaVisits

  describe "part1/1" do
    test "one step", do: assert part1(">") == 2
    test "up right down left", do: assert part1("^>v<") == 4
    test "repeat up down up down", do: assert part1("^v^v^v^v^v") == 2
  end

  describe "part2/1" do
    test "one step each", do: assert part2("^v") == 3
    test "up right down left", do: assert part2("^>v<") == 3
    test "repeat up down up down", do: assert part2("^v^v^v^v^v") == 11
  end
end
