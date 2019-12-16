defmodule IntcodeTest do
  use ExUnit.Case
  import Intcode

  test "simple program" do
    assert run([1, 0, 0, 3, 99]).code |> Map.values() == [1, 0, 0, 2, 99]
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
      assert run([4, 3, 99, 123]).outputs == [123]
    end

    test "jump if true" do
      # true
      assert run([5, 1, 4, 99, 4, 0, 99]).outputs == [5]
      # false
      assert run([105, 0, 4, 99, 4, 0, 99]).outputs == []
    end

    test "jump if false" do
      # true
      assert run([6, 1, 4, 99, 4, 0, 99]).outputs == []
      # false
      assert run([106, 0, 4, 99, 4, 0, 99]).outputs == [106]
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

    test "adjust relative base" do
      assert run([109, 10, 99]).relative_base == 10
    end
  end

  describe "immediate mode" do
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
      assert run([104, 123, 99]).outputs == [123]
    end
  end

  describe "relative mode" do
    test "is the same as position mode if relative base is 0 (the default)" do
      relative_mode = [2201, 3, 3, 5, 4, 5, 99, 0]
      position_mode = [0001, 3, 3, 5, 4, 5, 99, 0]
      assert run(relative_mode).outputs == run(position_mode).outputs
    end

    test "is offset by the relative base" do
      assert run([109, 8, 2201, 0, 0, 9, 4, 9, 99, 0]).outputs == [99 + 99]
    end

    test "write position can be relative" do
      assert run([109, 9, 21101, 10, 10, 0, 4, 9, 99, 0]).outputs == [20]
    end
  end

  describe "the program can pause waiting for input" do
    test "waiting" do
      assert {:waiting, _state} = run([3, 3, 99, 0])
    end

    test "resuming" do
      {:waiting, state} = run([3, 3, 99, 0])
      assert run(input(state, 123)).code[3] == 123
    end
  end

  test "programs must terminate" do
    assert_raise(ArgumentError, fn -> run([1, 0, 0, 3]) end)
  end

  test "programs can access memory that's not in the input" do
    assert run([4, 1000, 99]).outputs == [0]
  end

  test "instruction/1 returns instruction and list of modes" do
    assert instruction(101) == {1, [1]}
    assert instruction(1001) == {1, [0, 1]}
  end

  test "modes/1 returns list of modes" do
    assert modes(10) == [0, 1]
  end

  describe "positions/4" do
    test "takes arity, state, current position and modes, returns position to read or write" do
      assert positions(2, load([1001, 0, 10, 3, 99]), 0, [0, 1]) == [0, 2]
    end
  end

  describe "position/3 takes state, position and mode, returns position to read or write" do
    test "in position mode" do
      assert position(load([1001, 0, 10, 3, 99]), 1, 0) == 0
    end

    test "in immediate mode" do
      assert position(load([1001, 0, 10, 3, 99]), 2, 1) == 2
    end

    test "in relative mode" do
      state = %{load([2001, 0, 10, 3, 99]) | relative_base: -10}
      assert position(state, 2, 2) == 0
    end
  end
end
