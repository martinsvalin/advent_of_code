defmodule InverseCaptchaTest do
  use ExUnit.Case
  import InverseCaptcha
  doctest InverseCaptcha

  describe "sum_matching_next" do
    test "given test cases" do
      assert sum_matching_next("1122") == 3
      assert sum_matching_next("1111") == 4
      assert sum_matching_next("1234") == 0
      assert sum_matching_next("91212129") == 9
    end
  end

  describe "sum_matching_across" do
    test "given test cases" do
      assert sum_matching_across("1212") == 6
      assert sum_matching_across("1221") == 0
      assert sum_matching_across("123425") == 4
      assert sum_matching_across("123123") == 12
      assert sum_matching_across("12131415") == 4
    end
  end
end
