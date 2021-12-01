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

  @bigger_example """
  42: 9 14 | 10 1
  9: 14 27 | 1 26
  10: 23 14 | 28 1
  1: "a"
  11: 42 31
  5: 1 14 | 15 1
  19: 14 1 | 14 14
  12: 24 14 | 19 1
  16: 15 1 | 14 14
  31: 14 17 | 1 13
  6: 14 14 | 1 14
  2: 1 24 | 14 4
  0: 8 11
  13: 14 3 | 1 12
  15: 1 | 14
  17: 14 2 | 1 7
  23: 25 1 | 22 14
  28: 16 1
  4: 1 1
  20: 14 14 | 1 15
  3: 5 14 | 16 1
  27: 1 6 | 14 18
  14: "b"
  21: 14 1 | 1 14
  25: 1 1 | 1 14
  22: 14 14
  8: 42
  26: 14 22 | 1 20
  18: 15 15
  7: 14 5 | 1 21
  24: 14 1

  abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
  bbabbbbaabaabba
  babbbbaabbbbbabbbbbbaabaaabaaa
  aaabbbbbbaaaabaababaabababbabaaabbababababaaa
  bbbbbbbaaaabbbbaaabbabaaa
  bbbababbbbaaaaaaaabbababaaababaabab
  ababaaaaaabaaab
  ababaaaaabbbaba
  baabbaaaabbaaaababbaababb
  abbbbabbbbaaaababbbbbbaaaababb
  aaaaabbaabaaaaababaa
  aaaabbaaaabbaaa
  aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
  babaaabbbaaabaababbaabababaaab
  aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
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

    test "bigger example matches 3 messages" do
      parsed = MM.parse(@bigger_example)
      assert Enum.count(parsed.messages, &MM.match?(&1, parsed.rules)) == 3
    end

    @tag :skip
    test "if we modify the rules, 12 messages in the bigger example match" do
      parsed = MM.parse(@bigger_example)
      rules = MM.modify_rules(parsed.rules)
      assert Enum.count(parsed.messages, &MM.match?(&1, rules)) == 12
    end

    test "a short message that should match with modified rules" do
      parsed = @bigger_example |> MM.parse() |> MM.modify_rules()
      assert MM.match?("aaaabbaaaabbaaa", parsed.rules)
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
