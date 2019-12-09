defmodule IntcodeTest do
  use ExUnit.Case
  import Intcode
  import ExUnit.CaptureIO

  test "simple program" do
    assert run([1, 0, 0, 3, 99]).code |> Map.values() == [1, 0, 0, 2, 99]
  end

  test "puzzle example programs" do
    assert run([1, 0, 0, 0, 99]).code |> Map.values() == [2, 0, 0, 0, 99]
    assert run([2, 3, 0, 3, 99]).code |> Map.values() == [2, 3, 0, 6, 99]
    assert run([2, 4, 4, 5, 99, 0]).code |> Map.values() == [2, 4, 4, 5, 99, 9801]
    assert run([1, 1, 1, 4, 99, 5, 6, 0, 99]).code[0] == 30
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
      assert run([4, 3, 99, 123]).outputs |> hd() == {0, 123}
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
