defmodule CoprocessorConflagrationTest do
  use ExUnit.Case
  import CoprocessorConflagration

  describe "count_mul_ops/1" do
    test "with a set and 2 mul" do
      input = """
      set a 2
      mul a 2
      mul a 2
      """

      assert count_mul_ops(input) == 2
    end

    test "with a jump instruction" do
      input = """
      set a 2
      set b 2
      sub b 1
      mul a 2
      mul a 2
      jgz b -3
      """

      assert count_mul_ops(input) == 4
    end
  end
end
