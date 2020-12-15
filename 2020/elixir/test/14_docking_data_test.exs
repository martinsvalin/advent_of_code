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
      assert [{:mask, 0, 0, xs}] =
               DockingData.parse(["mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"])

      assert xs == Enum.to_list(35..0)
    end

    test "parses 'mask = 010X1100101X00X01001X11010X111100X01'" do
      zeros = (:math.pow(2, 35) + 2) |> trunc()
      ones = (:math.pow(2, 34) + 1) |> trunc()
      xs = Enum.to_list(33..2)

      assert [{:mask, ^zeros, ^ones, ^xs}] =
               DockingData.parse(["mask = 01XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX01"])
    end

    test "parses 'mem[123] = 456'" do
      assert DockingData.parse(["mem[123] = 456"]) == [{:mem, 123, 456}]
    end

    test "parses example" do
      assert [{:mask, 2, 64, _}, {:mem, 8, 11}, {:mem, 7, 101}, {:mem, 8, 0}] =
               DockingData.parse(@example)
    end
  end
end
