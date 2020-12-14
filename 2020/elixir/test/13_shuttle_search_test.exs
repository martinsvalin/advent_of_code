defmodule ShuttleSearchTest do
  use ExUnit.Case

  @example ["939", "7,13,x,x,59,x,31,19"]
  describe "nearest_departure_time/1" do
    test "given example" do
      assert ShuttleSearch.nearest_departure_time(@example) ==
               {944, 59, 59 * (944 - 939)}
    end
  end

  describe "win_the_contest_by_search/1" do
    test "example 1: 7,13,x,x,59,x,31,19" do
      assert ShuttleSearch.win_the_contest_by_search("7,13,x,x,59,x,31,19") == 1_068_781
    end

    test "example 2: 17,x,13,19" do
      assert ShuttleSearch.win_the_contest_by_search("17,x,13,19") == 3417
    end

    test "example 3: 67,7,59,61" do
      assert ShuttleSearch.win_the_contest_by_search("67,7,59,61") == 754_018
    end

    test "example 4: 67,x,7,59,61" do
      assert ShuttleSearch.win_the_contest_by_search("67,x,7,59,61") == 779_210
    end

    test "example 5: 67,7,x,59,61" do
      assert ShuttleSearch.win_the_contest_by_search("67,7,x,59,61") == 1_261_476
    end

    @tag :slow
    test "example 6 is kind of slow: 1789,37,47,1889" do
      assert ShuttleSearch.win_the_contest_by_search("1789,37,47,1889") == 1_202_161_486
    end
  end

  describe "win_the_contest_by_sieve/1" do
    test "example 1: 7,13,x,x,59,x,31,19" do
      assert ShuttleSearch.win_the_contest_by_sieve("7,13,x,x,59,x,31,19") == 1_068_781
    end

    test "example 2: x,x,13,19,x,x,x,x,x,x,x,x,x,x,x,x,x,17" do
      assert ShuttleSearch.win_the_contest_by_sieve("17,x,13,19") == 3417
    end

    test "example 3: 67,7,59,61" do
      assert ShuttleSearch.win_the_contest_by_sieve("67,7,59,61") == 754_018
    end

    test "example 4: 67,x,7,59,61" do
      assert ShuttleSearch.win_the_contest_by_sieve("67,x,7,59,61") == 779_210
    end

    test "example 5: 67,7,x,59,61" do
      assert ShuttleSearch.win_the_contest_by_sieve("67,7,x,59,61") == 1_261_476
    end

    test "example 6: 1789,37,47,1889" do
      assert ShuttleSearch.win_the_contest_by_sieve("1789,37,47,1889") == 1_202_161_486
    end
  end
end
