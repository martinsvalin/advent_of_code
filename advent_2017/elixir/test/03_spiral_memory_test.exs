defmodule SpiralMemoryTest do
  use ExUnit.Case

  describe "spiral" do
    test "given test cases" do
      values = [
        147,  142,  133,  122,   59,
        304,    5,    4,    2,   57,
        330,   10,    1,    1,   54,
        351,   11,   23,   25,   26,
        362,  747,  806,
      ]
      keys = [
        {-2,  2}, {-1,  2}, {0,  2}, {1,  2}, {2,  2},
        {-2,  1}, {-1,  1}, {0,  1}, {1,  1}, {2,  1},
        {-2,  0}, {-1,  0}, {0,  0}, {1,  0}, {2,  0},
        {-2, -1}, {-1, -1}, {0, -1}, {1, -1}, {2, -1},
        {-2, -2}, {-1, -2}, {0, -2}, {1, -2}, {2, -2}
      ]

      assert SpiralMemory.spiral(806) == Map.new(Enum.zip keys, values)
    end
  end
end
