defmodule AdapterArrayTest do
  use ExUnit.Case

  @small_example [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]

  @given_example [
    28,
    33,
    18,
    42,
    31,
    14,
    46,
    20,
    48,
    47,
    24,
    23,
    49,
    45,
    19,
    38,
    39,
    11,
    1,
    32,
    25,
    35,
    8,
    17,
    7,
    9,
    4,
    2,
    34,
    10,
    3
  ]

  describe "full_array_differences/1" do
    test "simple, counting the 3-difference to the device as well" do
      assert AdapterArray.full_array_differences([1, 2, 3, 4]) ==
               %{1 => 4, 3 => 1}
    end

    test "small given example" do
      assert AdapterArray.full_array_differences(@small_example) ==
               %{1 => 7, 3 => 5}
    end

    test "larger given example" do
      assert AdapterArray.full_array_differences(@given_example) ==
               %{1 => 22, 3 => 10}
    end
  end

  describe "count_combinations/1" do
    test "simple, counting combinations of a short sequence" do
      assert AdapterArray.count_combinations([1, 2, 3, 4]) == 7
    end

    test "works even if adapter list is very short" do
      assert AdapterArray.count_combinations([1]) == 1
    end

    test "or even empty" do
      assert AdapterArray.count_combinations([]) == 1
    end

    test "a small given example" do
      assert AdapterArray.count_combinations(@small_example) == 8
    end

    test "a larger given example" do
      assert AdapterArray.count_combinations(@given_example) == 19208
    end
  end
end
