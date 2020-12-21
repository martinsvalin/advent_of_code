defmodule MonsterMessagesTest do
  use ExUnit.Case
  alias MonsterMessages, as: MM

  @example """
  0: 4 1 5
  1: 2 3 | 3 2
  2: 4 4 | 5 5
  3: 4 5 | 5 4
  4: "a"
  5: "b"

  ababbb
  bababa
  abbbab
  aaabbb
  aaaabbb
  """

  describe "match?/2" do
    @rules MM.parse(@example).rules
    @messages MM.parse(@example).messages
    @answers [true, false, true, false, false]

    for {message, expected} <- Enum.zip(@messages, @answers) do
      test "with message: #{message}" do
        assert MM.match?(unquote(message), @rules) == unquote(expected)
      end
    end
  end

  describe "parse/1" do
    test "parses input into rules and messages" do
      assert MM.parse(@example) ==
               %{
                 rules: %{
                   0 => [[4, 1, 5]],
                   1 => [[2, 3], [3, 2]],
                   2 => [[4, 4], [5, 5]],
                   3 => [[4, 5], [5, 4]],
                   4 => "a",
                   5 => "b"
                 },
                 messages: [
                   "ababbb",
                   "bababa",
                   "abbbab",
                   "aaabbb",
                   "aaaabbb"
                 ]
               }
    end
  end
end
