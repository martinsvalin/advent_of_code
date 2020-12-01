defmodule ReportRepairTest do
  use ExUnit.Case

  describe "find_two_with_sum/2" do
    test "1,2,3,4 has 2,4 sum to 6" do
      assert ReportRepair.find_two_with_sum([1, 2, 3, 4], 6) == {:ok, 2, 4}
    end

    test "1,2,3,4 can't sum to 8" do
      assert ReportRepair.find_two_with_sum([1, 2, 3, 4], 8) ==
               {:error, "no two numbers sum to 8"}
    end

    test "given example, sum to 2020" do
      assert ReportRepair.find_two_with_sum([1721, 979, 366, 299, 675, 1456]) ==
               {:ok, 1721, 299}
    end
  end

  describe "find_three_with_sum/2" do
    test "1,2,3,4 has 2,3,4 sum to 9" do
      assert ReportRepair.find_three_with_sum([1, 2, 3, 4], 9) == {:ok, 2, 3, 4}
    end

    test "1,2,3,4 has no sum to 10" do
      assert ReportRepair.find_three_with_sum([1, 2, 3, 4], 10) ==
               {:error, "no three numbers sum to 10"}
    end

    test "given example, sum to 2020" do
      assert ReportRepair.find_three_with_sum([1721, 979, 366, 299, 675, 1456]) ==
               {:ok, 979, 366, 675}
    end
  end
end
