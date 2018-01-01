defmodule AdventCoinTest do
  use ExUnit.Case
  
  @tag :slow
  describe "mine/2" do
    test "looking for 5 consecutive zeroes" do
      assert AdventCoin.mine("abcdef", 5) == 609_043
      assert AdventCoin.mine("pqrstuv", 5) == 1_048_970
    end
  end
end