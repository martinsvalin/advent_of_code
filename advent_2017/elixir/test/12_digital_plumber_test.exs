defmodule DigitalPlumberTest do
  use ExUnit.Case
  import DigitalPlumber

  @simple """
    0 <-> 2
    1 <-> 1
    2 <-> 0, 3, 4
    3 <-> 2, 4
    4 <-> 2, 3, 6
    5 <-> 6
    6 <-> 4, 5
  """

  describe "group_size/2" do
    test "a simple case" do
      assert group_size(@simple, 0) == 6
    end
  end

  describe "groups/1" do
    test "a simple case" do
      assert groups(@simple) |> Enum.map(&Enum.sort/1) == [[1], [0, 2, 3, 4, 5, 6]]
    end
  end
end
