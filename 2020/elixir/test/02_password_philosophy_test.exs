defmodule PasswordPhilosophyTest do
  use ExUnit.Case

  describe "count_valid_passwords_by_frequency/1" do
    test "where we want 1-3 `a` characters and have a valid password" do
      assert PasswordPhilosophy.count_valid_passwords_by_frequency(["1-3 a: abc"]) == 1
    end

    test "where we want 1-3 `d` characters and have an invalid password" do
      assert PasswordPhilosophy.count_valid_passwords_by_frequency(["1-3 d: abc"]) == 0
    end

    test "given example" do
      lines = ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]
      assert PasswordPhilosophy.count_valid_passwords_by_frequency(lines) == 2
    end
  end

  describe "count_valid_passwords_by_position" do
    test "where we want an `a` character at positions 1 xor 3, with a valid password" do
      assert PasswordPhilosophy.count_valid_passwords_by_position(["1-3 a: abc"]) == 1
    end

    test "where we want an `a` character at positions 1 xor 3, with no `a` in the password" do
      assert PasswordPhilosophy.count_valid_passwords_by_position(["1-3 a: dbc"]) == 0
    end

    test "where we want an `a` character at positions 1 xor 3, with `a` in both positions" do
      assert PasswordPhilosophy.count_valid_passwords_by_position(["1-3 a: aba"]) == 0
    end

    test "given example" do
      lines = ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]
      assert PasswordPhilosophy.count_valid_passwords_by_position(lines) == 1
    end
  end
end
