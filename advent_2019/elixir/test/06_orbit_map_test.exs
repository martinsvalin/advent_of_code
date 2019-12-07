defmodule OrbitMapTest do
  use ExUnit.Case

  @example [
    "COM)B",
    "B)C",
    "C)D",
    "D)E",
    "E)F",
    "B)G",
    "G)H",
    "D)I",
    "E)J",
    "J)K",
    "K)L"
  ]

  describe "checksum/1 is the sum of all orbits, direct and indirect" do
    test "it works" do
      map = OrbitalMap.build_graph(["COM)B", "B)C"])
      assert OrbitalMap.checksum(map) == 3
    end

    test "puzzle example" do
      map = OrbitalMap.build_graph(@example)
      assert OrbitalMap.checksum(map) == 42
    end
  end

  describe "transfers/1 counts the transfers from one object to another" do
    test "puzzle example" do
      map = OrbitalMap.build_graph(@example ++ ["K)YOU", "I)SAN"])
      assert OrbitalMap.transfers(map, "YOU", "SAN") == 4
    end
  end
end
