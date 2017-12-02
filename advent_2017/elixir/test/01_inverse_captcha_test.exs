defmodule InverseCaptchaTest do
  use ExUnit.Case
  import InverseCaptcha
  doctest InverseCaptcha

  describe "sum_matching_next" do
    test "given test cases" do
      assert sum_matching_next([1,1,2,2]) == 3
      assert sum_matching_next([1,1,1,1]) == 4
      assert sum_matching_next([1,2,3,4]) == 0
      assert sum_matching_next([9,1,2,1,2,1,2,9]) == 9
    end
  end
end
