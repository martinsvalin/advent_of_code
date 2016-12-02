defmodule Advent.BathroomSecurityTest do
  use ExUnit.Case
  import Advent.BathroomSecurity
  doctest Advent.BathroomSecurity

  test "Single line, go up once from 5 to 2" do
    assert decode("U") == "2"
  end

  test "Single line, go up twice, but stay at 2" do
    assert decode("UU") == "2"
  end

  test "Single line, all directions ends back at 5" do
    assert decode("ULDR") == "5"
  end

  test "Mulitple lines" do
    assert decode("U\nD\nL\nR") == "2545"
  end
end
