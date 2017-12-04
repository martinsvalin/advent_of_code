defmodule HighEntropyPassphrasesTest do
  use ExUnit.Case
  import HighEntropyPassphrases
  doctest HighEntropyPassphrases

  describe "valid?" do
    test "given test cases" do
      assert valid?("aa bb cc dd ee")
      refute valid?("aa bb cc dd aa")
      assert valid?("aa bb cc dd aaa")
    end

    test "normalised for anagram" do
      assert valid?("abcde fghij", &for_anagram/1)
      refute valid?("abcde xyz ecdab", &for_anagram/1)
      assert valid?("a ab abc abd abf abj", &for_anagram/1)
      assert valid?("iiii oiii ooii oooi oooo", &for_anagram/1)
      refute valid?("oiii ioii iioi iiio", &for_anagram/1)
    end
  end
end