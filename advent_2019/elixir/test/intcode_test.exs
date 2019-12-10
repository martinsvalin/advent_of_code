defmodule IntcodeTest do
  use ExUnit.Case
  import Intcode

  test "simple program" do
    assert run([1, 0, 0, 3, 99]).code |> Map.values() == [1, 0, 0, 2, 99]
  end

  test "day 2 puzzle example programs" do
    assert run([1, 0, 0, 0, 99]).code |> Map.values() == [2, 0, 0, 0, 99]
    assert run([2, 3, 0, 3, 99]).code |> Map.values() == [2, 3, 0, 6, 99]
    assert run([2, 4, 4, 5, 99, 0]).code |> Map.values() == [2, 4, 4, 5, 99, 9801]
    assert run([1, 1, 1, 4, 99, 5, 6, 0, 99]).code[0] == 30
  end

  test "day 5 puzzle example programs" do
    # position mode, equals
    assert [{_, 1}] = run([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], [8]).outputs
    assert [{_, 0}] = run([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], [-8]).outputs
    # position mode, less than
    assert [{_, 1}] = run([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], [7]).outputs
    assert [{_, 0}] = run([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], [8]).outputs
    # immediate mode, equals
    assert [{_, 1}] = run([3, 3, 1108, -1, 8, 3, 4, 3, 99], [8]).outputs
    assert [{_, 0}] = run([3, 3, 1108, -1, 8, 3, 4, 3, 99], [9]).outputs
    # immediate mode, less than
    assert [{_, 1}] = run([3, 3, 1107, -1, 8, 3, 4, 3, 99], [7]).outputs
    assert [{_, 0}] = run([3, 3, 1107, -1, 8, 3, 4, 3, 99], [8]).outputs
    # jump
    assert [{_, 0}] = run([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9], [0]).outputs
    assert [{_, 1}] = run([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9], [8]).outputs
  end

  @longer_program Util.file_contents("05_test.txt") |> Util.numbers()
  test "day 5 with longer program example" do
    # less than 8 gives 999
    assert [{_, 999}] = run(@longer_program, [7]).outputs
    # exactly 8 gives 1000
    assert [{_, 1000}] = run(@longer_program, [8]).outputs
    # greater than 8 gives 1001
    assert [{_, 1001}] = run(@longer_program, [9]).outputs
  end

  describe "operations" do
    test "addition" do
      assert run([1, 0, 0, 5, 99, 0]).code[5] == 2
    end

    test "multiplication" do
      assert run([2, 0, 0, 5, 99, 0]).code[5] == 4
    end

    test "termination" do
      assert run([99, 1, 0, 0, 4]).code |> Map.values() == [99, 1, 0, 0, 4]
    end

    test "input" do
      assert run([3, 3, 99, 0], [111]).code |> Map.values() == [3, 3, 99, 111]
    end

    test "output" do
      assert run([4, 3, 99, 123]).outputs == [{0, 123}]
    end

    test "jump if true" do
      # true
      assert run([5, 1, 4, 99, 4, 0, 99]).outputs == [{4, 5}]
      # false
      assert run([105, 0, 4, 99, 4, 0, 99]).outputs == []
    end

    test "jump if false" do
      # true
      assert run([6, 1, 4, 99, 4, 0, 99]).outputs == []
      # false
      assert run([106, 0, 4, 99, 4, 0, 99]).outputs == [{4, 106}]
    end

    test "less than" do
      assert run([1107, 1, 2, 5, 99, 123]).code[5] == 1
      assert run([1107, 2, 2, 5, 99, 123]).code[5] == 0
      assert run([1107, 3, 2, 5, 99, 123]).code[5] == 0
    end

    test "equals" do
      assert run([1108, 1, 2, 5, 99, 123]).code[5] == 0
      assert run([1108, 2, 2, 5, 99, 123]).code[5] == 1
      assert run([1108, 3, 2, 5, 99, 123]).code[5] == 0
    end
  end

  describe "modes" do
    test "addition in immediate mode for both operands" do
      assert run([1101, 10, 20, 5, 99, 0]).code[5] == 30
    end

    test "addition with one operand in immediate mode" do
      assert run([1001, 0, 10, 5, 99, 0]).code[5] == 1011
    end

    test "leading zeros are implied" do
      assert run([101, 10, 0, 5, 99, 0]).code[5] == 111
    end

    test "output can be immediate mode" do
      assert run([104, 123, 99]).outputs |> hd == {0, 123}
    end
  end

  test "programs must terminate" do
    assert_raise(ArgumentError, fn -> run([1, 0, 0, 3]) end)
  end

  test "instruction/1 returns instruction and list of modes" do
    assert instruction(101) == {1, [1]}
    assert instruction(1001) == {1, [0, 1]}
  end

  test "modes/1 returns list of modes" do
    assert modes(10) == [0, 1]
  end

  describe "values/4" do
    setup(do: Intcode.to_code([1001, 0, 10, 3, 99]))

    test "takes arity, code, current position and modes, returns values", code do
      assert values(2, code, 0, [0, 1]) == [1001, 10]
    end
  end

  describe "value/3 takes code, position and mode, returns value" do
    setup(do: Intcode.to_code([1, 0, 10, 3, 99]))
    test("in position mode", code, do: assert(value(code, 1, 0) == 1))
    test("in immediate mode", code, do: assert(value(code, 2, 1) == 10))
  end
end
