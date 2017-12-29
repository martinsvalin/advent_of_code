defmodule ElectromagneticMoatTest do
  use ExUnit.Case
  import ElectromagneticMoat
  doctest ElectromagneticMoat

  describe "strongest_bridge/1" do
    test "with a few components" do
      input = "0/2\n2/2\n2/3\n3/4\n3/5\n0/1\n10/1\n9/10"
      assert strongest_bridge(input) == 31
    end
  end
end
