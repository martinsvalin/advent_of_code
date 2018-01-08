defmodule NiceStringsTest do
  use ExUnit.Case
  import NiceStrings

  describe "nice?/1" do
    test "simple nice string", do: assert(nice?("ugknbfddgicrmopn"))
    test "rules can overlap", do: assert(nice?("aaa"))
    test "no double letter", do: refute(nice?("jchzalrnumimnmhp"))
    test "disallowed substring", do: refute(nice?("haegwjzuvuyypxyu"))
    test "too few vowels", do: refute(nice?("dvszwmarrgswjxmb"))
  end

  describe "nicer?/1" do
    test "a nice string", do: assert(nicer?("qjhvhtzxzqqjkmpb"))
    test "minimally nice", do: assert(nicer?("xxyxx"))
    test "no repeat with single letter between", do: refute(nicer?("uurcxstgmygtbstg"))
    test "no pair that appears twice", do: refute(nicer?("ieodomkazucvgmuy"))
    test "overlapping pairs", do: refute(nicer?("aaa"))
  end
end
