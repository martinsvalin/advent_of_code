defmodule RecursiveCircusTest do
  use ExUnit.Case

  @input """
    pbga (66)
    xhth (57)
    ebii (61)
    havc (66)
    ktlj (57)
    fwft (72) -> ktlj, cntj, xhth
    qoyq (66)
    padx (45) -> pbga, havc, qoyq
    tknk (41) -> ugml, padx, fwft
    jptl (61)
    ugml (68) -> gyxo, ebii, jptl
    gyxo (61)
    cntj (57)
  """

  describe "root" do
    test "given test case" do
      assert RecursiveCircus.root(@input) == "tknk"
    end
  end

  describe "unbalanced" do
    test "given test case" do
      assert RecursiveCircus.correct_weight(@input) == 60
    end
  end
end
