defmodule LikeRegistersTest do
  use ExUnit.Case

  @input """
    b inc 5 if a > 1
    a inc 1 if b < 5
    c dec -10 if a >= 1
    c inc -20 if c == 10
  """

  describe "eval" do
    test "returns registers with values, and max value seen" do
      assert LikeRegisters.eval(@input) == {%{"a" => 1, "b" => 0, "c" => -10}, 10}
    end
  end

  describe "max_after" do
    test "answers part 1" do
      assert LikeRegisters.max_after(@input) == 1
    end
  end

  describe "max_during" do
    test "answers part 2" do
      assert LikeRegisters.max_during(@input) == 10
    end
  end
end
