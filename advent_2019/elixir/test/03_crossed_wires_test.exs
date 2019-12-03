defmodule CrossedWiresTest do
  use ExUnit.Case
  import CrossedWires
  doctest CrossedWires

  describe "part 1: distance of closest crossing to origo, not counting origo itself" do
    test "simple case" do
      assert part1(["U1,R1", "R1,U1"]) == 2
    end

    test "it works for puzzle example" do
      assert part1(["R8,U5,L5,D3", "U7,R6,D4,L4"]) == 6

      assert part1([
               "R75,D30,R83,U83,L12,D49,R71,U7,L72",
               "U62,R66,U55,R34,D71,R55,D58,R83"
             ]) == 159

      assert part1([
               "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
               "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
             ]) == 135
    end
  end

  describe "part 2: shortest combined path to a crossing" do
    test "simple case" do
      assert part2(["U1,R1", "R1,U1"]) == 4
    end

    test "it works for puzzle example" do
      assert part2(["R8,U5,L5,D3", "U7,R6,D4,L4"]) == 30

      assert part2([
               "R75,D30,R83,U83,L12,D49,R71,U7,L72",
               "U62,R66,U55,R34,D71,R55,D58,R83"
             ]) == 610

      assert part2([
               "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
               "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
             ]) == 410
    end
  end

  describe "crossings/2" do
    test "it finds intersecting coordinates in two paths" do
      assert crossings([{0, 0}, {1, 0}, {1, 1}], [{0, 0}, {0, 1}, {1, 1}]) == [{1, 1}]
    end

    test "it does not count origo as a crossing" do
      assert crossings([{0, 0}], [{0, 0}]) == []
    end
  end

  describe "path/1" do
    test "it builds a list of coordinates from direction and steps" do
      assert path("R2,U3") == [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}, {2, 3}]
      assert path("L1,D2") == [{0, 0}, {-1, 0}, {-1, -1}, {-1, -2}]
    end
  end

  describe "parse/1" do
    test "parses string into directions and steps" do
      assert parse("R2,U3") == [{:right, 2}, {:up, 3}]
      assert parse("L1,D2") == [{:left, 1}, {:down, 2}]
    end
  end
end
