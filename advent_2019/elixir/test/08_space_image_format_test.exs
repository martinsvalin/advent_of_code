defmodule SpaceImageFormatTest do
  use ExUnit.Case
  alias SpaceImageFormat, as: SIF

  test "part1" do
    assert SIF.part1("001002110120", 3, 2) == 3
  end

  test "part2" do
    assert SIF.part2("0222112222120000", 2, 2) == ['.#', '#.']
  end
end
