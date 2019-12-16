defmodule MercuryFlybyTest do
  use ExUnit.Case
  import Intcode, only: [run: 2]

  describe "day 5 puzzle example programs" do
    test "position mode, equals" do
      assert run([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], [8]).outputs == [1]
      assert run([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], [-8]).outputs == [0]
    end

    test "position mode, less than" do
      assert run([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], [7]).outputs == [1]
      assert run([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], [8]).outputs == [0]
    end

    test "immediate mode, equals" do
      assert run([3, 3, 1108, -1, 8, 3, 4, 3, 99], [8]).outputs == [1]
      assert run([3, 3, 1108, -1, 8, 3, 4, 3, 99], [9]).outputs == [0]
    end

    test "immediate mode, less than" do
      assert run([3, 3, 1107, -1, 8, 3, 4, 3, 99], [7]).outputs == [1]
      assert run([3, 3, 1107, -1, 8, 3, 4, 3, 99], [8]).outputs == [0]
    end

    test "jump" do
      assert run([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9], [0]).outputs == [0]

      assert run([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9], [8]).outputs == [1]
    end
  end

  @longer_program Util.file_contents("05_test.txt") |> Util.numbers()
  describe "day 5 with longer program example" do
    test "less than 8 gives 999" do
      assert run(@longer_program, [7]).outputs == [999]
    end

    test "exactly 8 gives 1000" do
      assert run(@longer_program, [8]).outputs == [1000]
    end

    test "greater than 8 gives 1001" do
      assert run(@longer_program, [9]).outputs == [1001]
    end
  end
end
