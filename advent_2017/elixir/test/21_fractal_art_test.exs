defmodule FractalArtTest do
  use ExUnit.Case
  import FractalArt

  @rules """
  ../.# => ##./#../...
  .#./..#/### => #..#/..../..../#..#
  """

  describe "generate_art/2" do
    test "one iteration" do
      expected = """
      #..#
      ....
      ....
      #..#
      """

      assert generate_art(@rules, 1) == String.trim(expected)
    end

    test "two iterations" do
      expected = """
      ##.##.
      #..#..
      ......
      ##.##.
      #..#..
      ......
      """

      assert generate_art(@rules, 2) == String.trim(expected)
    end
  end
end
