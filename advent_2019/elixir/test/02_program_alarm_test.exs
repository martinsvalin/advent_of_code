defmodule ProgramAlarmTest do
  use ExUnit.Case
  import ProgramAlarm
  doctest ProgramAlarm

  describe "run/1" do
    test "simple program" do
      assert run([1, 0, 0, 3, 99]) == [1, 0, 0, 2, 99]
    end

    test "more programs" do
      assert run([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
      assert run([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
      assert run([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
      assert run([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]
    end

    test "99 terminates the program" do
      assert run([99]) == [99]
    end

    test "A program needs to terminate" do
      assert_raise(ArgumentError, fn -> run([1, 0, 0, 3]) end)
    end
  end

  test "day 2 puzzle example programs with Intcode module" do
    alias Intcode, as: I
    assert I.run([1, 0, 0, 0, 99]).code |> Map.values() == [2, 0, 0, 0, 99]
    assert I.run([2, 3, 0, 3, 99]).code |> Map.values() == [2, 3, 0, 6, 99]
    assert I.run([2, 4, 4, 5, 99, 0]).code |> Map.values() == [2, 4, 4, 5, 99, 9801]
    assert I.run([1, 1, 1, 4, 99, 5, 6, 0, 99]).code[0] == 30
  end
end
