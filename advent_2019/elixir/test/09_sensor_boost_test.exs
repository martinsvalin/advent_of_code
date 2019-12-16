defmodule SensorBoostTest do
  use ExUnit.Case

  @ex1 [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
  @ex2 [1102, 34_915_192, 34_915_192, 7, 4, 7, 99, 0]
  @ex3 [104, 1_125_899_906_842_624, 99]

  describe "part 1 puzzle examples" do
    test "quine" do
      assert Intcode.run(@ex1).outputs == Enum.reverse(@ex1)
    end

    test "multiply and output a 16-digit number" do
      large_number = Intcode.run(@ex2).outputs |> hd()
      assert length(Integer.digits(large_number)) == 16
    end

    test "output the given big number" do
      [_, num, _] = @ex3
      assert Intcode.run(@ex3).outputs == [num]
    end
  end
end
