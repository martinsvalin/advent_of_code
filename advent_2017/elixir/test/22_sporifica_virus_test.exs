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

    test "evolved, with 100 bursts" do
      assert SporificaVirus.virus_infections(@example_input, 100, true) == 26
    end
  end
end
