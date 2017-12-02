defmodule CorruptionCheckpointTest do
  use ExUnit.Case
  import CorruptionCheckpoint
  doctest CorruptionCheckpoint

  describe "checksum" do
    test "given test cases" do
      input = """
        5 1 9 5
        7 5 3
        2 4 6 8
      """

      assert checksum(input) == 18
    end
  end

  describe "divisible" do
    test "given test case" do
      input = """
        5 9 2 8
        9 4 7 3
        3 8 6 5
      """

      assert divisible(input) == 9
    end
  end
end
