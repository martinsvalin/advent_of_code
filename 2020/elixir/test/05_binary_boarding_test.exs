defmodule BinaryBoardingTest do
  use ExUnit.Case

  describe "max_seat_id" do
    test "finds the boarding pass with the highest seat id" do
      passes = ~w[BFFFBBFRRR FFFBBBFRRR BBFFBBFRLL]
      assert {:ok, _, _, 820} = BinaryBoarding.max_seat_id(passes)
    end
  end

  describe "seat_from_boarding_pass" do
    test "given example 1, BFFFBBFRRR has seat row 70, column 7, seat ID 567" do
      assert BinaryBoarding.seat_from_boarding_pass('BFFFBBFRRR') == {:ok, 70, 7, 567}
    end

    test "given example 2, FFFBBBFRRR has seat row 14, column 7, seat ID 119" do
      assert BinaryBoarding.seat_from_boarding_pass('FFFBBBFRRR') == {:ok, 14, 7, 119}
    end

    test "given example 3, BBFFBBFRLL has seat row 102, column 4, seat ID 820" do
      assert BinaryBoarding.seat_from_boarding_pass('BBFFBBFRLL') == {:ok, 102, 4, 820}
    end

    test "accepts binary input" do
      assert BinaryBoarding.seat_from_boarding_pass("BBFFBBFRLL") == {:ok, 102, 4, 820}
    end
  end
end
