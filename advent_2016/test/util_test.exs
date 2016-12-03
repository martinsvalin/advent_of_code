defmodule UtilTest do
  use ExUnit.Case
  doctest Util

  describe "invert_map" do
    test "overwrites duplicate values" do
      assert Util.invert_map(%{a: 1, a: 2}) == %{2 => :a}
    end
  end
end
