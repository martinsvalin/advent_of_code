defmodule CustomCustomsTest do
  use ExUnit.Case
  alias CustomCustoms, as: CC

  @given_example "abc\n\na\nb\nc\n\nab\nac\n\na\na\na\na\n\nb"

  describe "sum_group_answers/2" do
    test "given example, counting answers anyone gave" do
      assert CC.sum_group_answers(@given_example, &MapSet.union/2) == 11
    end

    test "given example, counting answers everyone gave" do
      assert CC.sum_group_answers(@given_example, &MapSet.intersection/2) == 6
    end
  end

  describe "collect_for_group/1" do
    test "a single persons answers are easy" do
      assert CC.collect_group_answers("abc") ==
               [[MapSet.new('abc')]]
    end

    test "two groups of one" do
      assert CC.collect_group_answers("abc\n\ndef") ==
               [[MapSet.new('abc')], [MapSet.new('def')]]
    end

    test "a group with multiple people" do
      assert CC.collect_group_answers("a\nb\nc") ==
               [[MapSet.new('a'), MapSet.new('b'), MapSet.new('c')]]
    end

    test "given example, five groups" do
      assert CC.collect_group_answers(@given_example) ==
               [
                 [MapSet.new('abc')],
                 [MapSet.new('a'), MapSet.new('b'), MapSet.new('c')],
                 [MapSet.new('ab'), MapSet.new('ac')],
                 [MapSet.new('a'), MapSet.new('a'), MapSet.new('a'), MapSet.new('a')],
                 [MapSet.new('b')]
               ]
    end
  end
end
