defmodule KnotHashTest do
  use ExUnit.Case
  doctest KnotHash

  describe "real_hash" do
    test "empty string" do
      assert KnotHash.real_hash("") == "a2582a3a0e66e6e86e3812dcb672a272"
    end

    test "AoC 2017" do
      assert KnotHash.real_hash("AoC 2017") == "33efeb34ea91902bb2f59c9920caa6cd"
    end

    test "numbers" do
      assert KnotHash.real_hash("1,2,3") == "3efbe78a8d82f29979031a4aa0b16a9d"
      assert KnotHash.real_hash("1,2,4") == "63960835bcdc130f0b66d7ff4f6a5a8e"
    end
  end
end
