defmodule ConwayCubesTest do
  use ExUnit.Case

  @example """
  .#.
  ..#
  ###
  """

  describe "run/2 executes a number of cycles on a given state" do
    test "example 1 cycle" do
      cubes = ConwayCubes.run(@example, 1)

      assert ConwayCubes.to_string(cubes, -1) ==
               """
               #..
               ..#
               .#.
               """

      assert ConwayCubes.to_string(cubes, 0) ==
               """
               #.#
               .##
               .#.
               """

      assert ConwayCubes.to_string(cubes, 1) ==
               """
               #..
               ..#
               .#.
               """
    end

    test "example 2 cycles" do
      cubes = ConwayCubes.run(@example, 2)

      assert ConwayCubes.to_string(cubes, -2) ==
               """
               .....
               .....
               ..#..
               .....
               .....
               """

      assert ConwayCubes.to_string(cubes, -1) ==
               """
               ..#..
               .#..#
               ....#
               .#...
               .....
               """

      assert ConwayCubes.to_string(cubes, 0) ==
               """
               ##...
               ##...
               #....
               ....#
               .###.
               """

      assert ConwayCubes.to_string(cubes, 1) ==
               """
               ..#..
               .#..#
               ....#
               .#...
               .....
               """

      assert ConwayCubes.to_string(cubes, 2) ==
               """
               .....
               .....
               ..#..
               .....
               .....
               """
    end

    test "example 3 cycles" do
      cubes = ConwayCubes.run(@example, 3)

      assert ConwayCubes.to_string(cubes, -2) ==
               """
               .......
               .......
               ..##...
               ..###..
               .......
               .......
               .......
               """

      assert ConwayCubes.to_string(cubes, -1) ==
               """
               ..#....
               ...#...
               #......
               .....##
               .#...#.
               ..#.#..
               ...#...
               """

      assert ConwayCubes.to_string(cubes, 0) ==
               """
               ...#...
               .......
               #......
               .......
               .....##
               .##.#..
               ...#...
               """

      assert ConwayCubes.to_string(cubes, 1) ==
               """
               ..#....
               ...#...
               #......
               .....##
               .#...#.
               ..#.#..
               ...#...
               """

      assert ConwayCubes.to_string(cubes, 2) ==
               """
               .......
               .......
               ..##...
               ..###..
               .......
               .......
               .......
               """
    end

    test "example 6 cycles" do
      cubes = ConwayCubes.run(@example, 6)
      assert MapSet.size(cubes) == 112
    end
  end

  describe "run/3 lets you run with 4 dimensions" do
    @tag :slow
    test "example 6 cycles" do
      cubes = ConwayCubes.run(@example, 6, 4)
      assert MapSet.size(cubes) == 848
    end
  end

  describe "parse/1" do
    test "gives a set of 4d coordinates of active cubes" do
      assert ConwayCubes.parse(@example) ==
               MapSet.new([{1, 0, 0, 0}, {2, 1, 0, 0}, {0, 2, 0, 0}, {1, 2, 0, 0}, {2, 2, 0, 0}])
    end
  end

  describe "to_string/2" do
    test "prints the 2d grid at the given z-index" do
      grid = MapSet.new([{1, 0, 0, 0}, {2, 1, 0, 0}, {0, 2, 0, 0}, {1, 2, 0, 0}, {2, 2, 0, 0}])

      assert ConwayCubes.to_string(grid, 0) == @example
    end
  end
end
