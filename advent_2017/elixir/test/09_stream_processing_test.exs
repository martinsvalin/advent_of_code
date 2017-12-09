defmodule StreamProcessingTest do
  use ExUnit.Case
  import StreamProcessing
  doctest StreamProcessing

  describe "score" do
    test "empty groups" do
      assert score("{}") == 1
      assert score("{{{}}}") == 6
      assert score("{{},{}}") == 5
      assert score("{{{},{},{{}}}}") == 16
    end

    test "groups with garbage" do
      assert score("{<a>,<a>,<a>,<a>}") == 1
      assert score("{{<ab>},{<ab>},{<ab>},{<ab>}}") == 9
    end

    test "groups with escaped characters" do
      assert score("{{<!!>},{<!!>},{<!!>},{<!!>}}") == 9
      assert score("{{<a!>},{<a!>},{<a!>},{<ab>}}") == 3
    end
  end
end
