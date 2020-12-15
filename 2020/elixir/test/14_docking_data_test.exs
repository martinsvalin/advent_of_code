defmodule DockingDataTest do
  use ExUnit.Case

  @example_v1 [
    "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X",
    "mem[8] = 11",
    "mem[7] = 101",
    "mem[8] = 0"
  ]

  @example_v2 [
    "mask = 000000000000000000000000000000X1001X",
    "mem[42] = 100",
    "mask = 00000000000000000000000000000000X0XX",
    "mem[26] = 1"
  ]

  describe "run/1" do
    test "with the given example" do
      assert DockingData.run(@example_v1) == %{
               7 => 101,
               8 => 64
             }
    end

    test "version 2 with the given example" do
      assert DockingData.run(@example_v2, :v2) == %{
               16 => 1,
               17 => 1,
               18 => 1,
               19 => 1,
               24 => 1,
               25 => 1,
               26 => 1,
               27 => 1,
               58 => 100,
               59 => 100
             }
    end
  end

  describe "mask/2" do
    test "mask 2,64 on 11" do
      assert DockingData.mask(11, {2, 64}) == 73
    end
  end

  describe "masks_from_xs/1" do
    test "X at positions 0, 5, like 000000000000000000000000000000X0000X" do
      assert DockingData.masks_from_xs([0, 5], 0) == [{0, 33}, {1, 32}, {32, 1}, {33, 0}]
    end

    test "X at positions 0, 5, 6like 00000000000000000000000000000XX0000X" do
      assert DockingData.masks_from_xs([0, 5, 6], 0) ==
               [{0, 97}, {1, 96}, {32, 65}, {33, 64}, {64, 33}, {65, 32}, {96, 1}, {97, 0}]
    end

    test "applies the ones for ready-to-go masks" do
      assert DockingData.masks_from_xs([0, 5], 18) == [{0, 51}, {1, 50}, {32, 19}, {33, 18}]
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
               DockingData.parse(@example_v1)
    end
  end
end
