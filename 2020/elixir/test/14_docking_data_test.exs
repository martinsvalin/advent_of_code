defmodule DockingDataTest do
  use ExUnit.Case

  @example [
    "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X",
    "mem[8] = 11",
    "mem[7] = 101",
    "mem[8] = 0"
  ]

  describe "run/1" do
    test "with the given example" do
      assert DockingData.run(@example) == %{7 => 101, 8 => 64}
    end
  end

  describe "mask/2" do
    test "mask 2,64 on 11" do
      assert DockingData.mask(11, {2, 64}) == 73
    end
  end

  describe "parse/1" do
    test "parses 'mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'" do
      assert DockingData.parse(["mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"]) ==
               [{:mask, 0, 0}]
    end

    test "parses 'mask = 010X1100101X00X01001X11010X111100X01'" do
      assert DockingData.parse(["mask = 01XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX01"]) ==
               [{:mask, (:math.pow(2, 35) + 2) |> trunc(), (:math.pow(2, 34) + 1) |> trunc()}]
    end

    test "parses 'mem[123] = 456'" do
      assert DockingData.parse(["mem[123] = 456"]) == [{:mem, 123, 456}]
    end

    test "parses example" do
      assert DockingData.parse(@example) ==
               [{:mask, 2, 64}, {:mem, 8, 11}, {:mem, 7, 101}, {:mem, 8, 0}]
    end
  end
end
