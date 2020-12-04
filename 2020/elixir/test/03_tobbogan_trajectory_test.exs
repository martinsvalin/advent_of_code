defmodule TobogganTrajectoryTest do
  use ExUnit.Case

  @given_tree_map [
    "..##.......",
    "#...#...#..",
    ".#....#..#.",
    "..#.#...#.#",
    ".#...##..#.",
    "..#.##.....",
    ".#.#.#....#",
    ".#........#",
    "#.##...#...",
    "#...##....#",
    ".#..#...#.#"
  ]

  describe "count_trees/2" do
    test "counts trees on the given trajectory" do
      assert TobogganTrajectory.count_trees(["..", ".#"], {1, 1}) == 1
    end

    test "works for trajectories with larger y-step" do
      assert TobogganTrajectory.count_trees(["....", "....", ".#..", "....", "..#."], {1, 2}) == 2
    end

    test "given example, trajectory 3,1" do
      assert TobogganTrajectory.count_trees(@given_tree_map, {3, 1}) == 7
    end
  end

  describe "multiply_tree_counts_for_trajetories/2" do
    test "counts trees for each trajectory, multiplying the counts" do
      map = ["....", ".#..", ".##.", "..##", "#..."]
      trajectories = [{1, 1}, {2, 1}]
      assert TobogganTrajectory.multiply_tree_counts_for_trajectories(map, trajectories) == 8
    end

    test "given example, trajectories 1,1; 3,1; 5,1; 7,1; 1,2" do
      trajectories = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

      assert TobogganTrajectory.multiply_tree_counts_for_trajectories(
               @given_tree_map,
               trajectories
             ) == 336
    end
  end

  describe "coordinates_on_trajectory/2" do
    test "generates coordinates on the trajectory, up to a limit on the y-axis" do
      assert TobogganTrajectory.coordinates_on_trajectory({3, 1}, 6) |> Enum.to_list() ==
               [{0, 0}, {3, 1}, {6, 2}, {9, 3}, {12, 4}, {15, 5}]
    end

    test "works for trajectories with larger y-step" do
      assert TobogganTrajectory.coordinates_on_trajectory({1, 2}, 6) |> Enum.to_list() ==
               [{0, 0}, {1, 2}, {2, 4}]
    end
  end
end
