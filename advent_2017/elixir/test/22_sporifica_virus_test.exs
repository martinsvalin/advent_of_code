defmodule SporificaVirusTest do
  use ExUnit.Case
  doctest SporificaVirus

  @example_input """
  ..#
  #..
  ...
  """

  describe "virus_infections/1" do
    test "seven bursts" do
      assert SporificaVirus.virus_infections(@example_input, 7) == 5
    end

    test "seventy bursts" do
      assert SporificaVirus.virus_infections(@example_input, 70) == 41
    end
  end
end
