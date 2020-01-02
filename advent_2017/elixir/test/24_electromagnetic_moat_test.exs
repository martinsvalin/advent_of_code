defmodule ElectromagneticMoatTest do
  use ExUnit.Case
  import ElectromagneticMoat
  doctest ElectromagneticMoat

  @example_input """
  0/2
  2/2
  2/3
  3/4
  3/5
  0/1
  10/1
  9/10
  """

  describe "strongest_bridge/1" do
    test "with a few components" do
      assert strongest_bridge(@example_input) == 31
    end
  end

  describe "longest_bridge/1" do
    test "with a few components" do
      assert longest_bridge(@example_input) == 19
    end
  end
end
