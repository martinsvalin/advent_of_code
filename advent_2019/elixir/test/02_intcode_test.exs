defmodule IntcodeTest do
  use ExUnit.Case
  doctest Intcode

  describe "run/1" do
    test "simple program" do
      assert Intcode.run([1, 0, 0, 3, 99]) == [1, 0, 0, 2, 99]
    end

    test "more programs" do
      assert Intcode.run([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
      assert Intcode.run([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
      assert Intcode.run([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
      assert Intcode.run([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]
    end

    test "99 terminates the program" do
      assert Intcode.run([99]) == [99]
    end

    test "A program needs to terminate" do
      assert_raise(ArgumentError, fn -> Intcode.run([1, 0, 0, 3]) end)
    end
  end

  describe "run2/1" do
    test "simple program" do
      assert Intcode.run2([1, 0, 0, 3, 99]) |> Map.values() == [1, 0, 0, 2, 99]
    end

    test "more programs" do
      assert Intcode.run2([1, 0, 0, 0, 99]) |> Map.values() == [2, 0, 0, 0, 99]
      assert Intcode.run2([2, 3, 0, 3, 99]) |> Map.values() == [2, 3, 0, 6, 99]
      assert Intcode.run2([2, 4, 4, 5, 99, 0]) |> Map.values() == [2, 4, 4, 5, 99, 9801]

      assert Intcode.run2([1, 1, 1, 4, 99, 5, 6, 0, 99])[0] == 30
    end

    test "99 terminates the program" do
      assert Intcode.run2([99]) |> Map.values() == [99]
    end

    test "A program needs to terminate" do
      assert_raise(ArgumentError, fn -> Intcode.run2([1, 0, 0, 3]) end)
    end
  end
end
