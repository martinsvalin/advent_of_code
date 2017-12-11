defmodule HexEdTest do
  use ExUnit.Case
  doctest HexEd

  describe "distance" do
    test "ne,ne,sw,sw" do
      assert HexEd.distance("ne,ne,sw,sw") == 0
    end

    test "taking a longer turn" do
      assert HexEd.distance("s,s,se,ne,n,n") == 2
    end
  end
end
