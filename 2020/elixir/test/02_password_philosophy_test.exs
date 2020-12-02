defmodule PasswordPhilosophyTest do
  use ExUnit.Case

  describe "count_valid_passwords/1" do
    test "with one valid line" do
      assert PasswordPhilosophy.count_valid_passwords(["1-3 a: abc"]) == 1
    end

    test "with one invalid line" do
      assert PasswordPhilosophy.count_valid_passwords(["1-3 a: bce"]) == 0
    end

    test "given example" do
      lines = ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]
      assert PasswordPhilosophy.count_valid_passwords(lines) == 2
    end
  end
end
