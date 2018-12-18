defmodule ChronalCoordinatesTest do
  use ExUnit.Case
  import ChronalCoordinates
  doctest ChronalCoordinates

  @input """
  1, 1
  1, 6
  8, 3
  3, 4
  5, 5
  8, 9
  """

  describe "parse_destinations/1" do
    test "parses coordinates per line into destinations set in accumulator" do
      acc = parse_destinations(@input)
      assert Enum.sort(acc.destinations) == [{1, 1}, {1, 6}, {3, 4}, {5, 5}, {8, 3}, {8, 9}]
    end
  end

  describe "bounding_box/1" do
    test "adds every coordinate in a minimal bounding box that contains the destinations" do
      acc = parse_destinations(@input)
      %{bounding_box: box} = bounding_box(acc)
      assert Enum.count(box) == 72
      assert [{1, 1}, {1, 2} | _] = Enum.sort(box)
    end
  end

  describe "group_areas/1" do
    test "groups coordinates in the box by the closest destination" do
      acc = @input |> parse_destinations() |> bounding_box() |> group_areas()
      assert acc.groups[{1, 1}] == [{1, 1}, {1, 2}, {1, 3}, {2, 1}, {2, 2}, {3, 1}, {4, 1}]
    end

    test "groups coordinates with equal distance to two destinations separately" do
      acc = @input |> parse_destinations() |> bounding_box() |> group_areas()
      assert {5, 1} in acc.groups[:equal]
    end
  end

  describe "closest/1" do
    test "returns the closest coordinate and distance in the list to a given coordinate" do
      assert closest([{1, 1}, {3, 3}], {1, 2}) == {1, 1}
    end

    test "returns :equal when two coordinates are equally close" do
      assert closest([{1, 1}, {2, 2}], {1, 2}) == :equal
    end
  end

  describe "discard_infinite_areas/1" do
    test "adds finite groups, i.e. those not touching the edge" do
      acc = @input |> parse_destinations() |> bounding_box() |> group_areas()
      assert Map.keys(discard_infinite_areas(acc).finite) == [{3, 4}, {5, 5}]
    end
  end

  describe "biggest_area/1" do
    test "selects the biggest finite area" do
      {destination, _} =
        @input
        |> parse_destinations()
        |> bounding_box()
        |> group_areas()
        |> discard_infinite_areas()
        |> biggest_area()

      assert destination == {5, 5}
    end
  end

  describe "print/1" do
    import ExUnit.CaptureIO

    test "prints labels" do
      acc = @input |> parse_destinations() |> bounding_box() |> group_areas()
      printed = capture_io(fn -> print(acc) end)
      assert String.contains?(printed, "b = {1, 1}, c = {1, 6}")
    end

    test "prints bright destinations" do
      acc = @input |> parse_destinations() |> bounding_box() |> group_areas()
      printed = capture_io(fn -> print(acc) end)
      assert String.contains?(printed, IO.ANSI.bright() <> "B")
    end
  end
end
