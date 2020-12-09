defmodule EncodingErrorTest do
  use ExUnit.Case

  @given_example [
    35,
    20,
    15,
    25,
    47,
    40,
    62,
    55,
    65,
    95,
    102,
    117,
    150,
    182,
    127,
    219,
    299,
    277,
    309,
    576
  ]

  describe "find_error/2 finds a number that isn't the sum of two numbers within the preamble window size" do
    test "when the number immediately after the preamble is too big" do
      assert EncodingError.find_error([1, 2, 3, 4, 5, 10, 15], 5) == 10
    end

    test "when there is an error two numbers after the preamble" do
      assert EncodingError.find_error([1, 2, 3, 4, 5, 6, 12, 14], 5) == 12
    end

    test "given example, with 5-number preamble" do
      assert EncodingError.find_error(@given_example, 5) == 127
    end
  end

  describe "find_encryption_weakness/2" do
    test "can find a range that sums to an invalid number, 5-number preamble" do
      assert EncodingError.find_encryption_weakness([1, 2, 3, 4, 5, 10], 5) == {1, 4}
    end

    test "can find a range for the given example" do
      assert EncodingError.find_encryption_weakness(@given_example, 5) == {15, 47}
    end
  end
end
