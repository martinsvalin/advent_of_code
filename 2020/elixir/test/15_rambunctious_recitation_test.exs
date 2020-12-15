defmodule RambunctiousRecitationTest do
  use ExUnit.Case
  alias RambunctiousRecitation, as: RR

  describe "speak/1 gives a stream of numbers" do
    test "with starting numbers 0,3,6" do
      assert RR.speak([0, 3, 6]) |> Enum.take(10) |> Enum.map(&elem(&1, 0)) ==
               [0, 3, 6, 0, 3, 3, 1, 0, 4, 0]
    end

    test "with starting numbers 0,3,6, 2020th number is 436" do
      assert RR.speak([0, 3, 6]) |> Enum.at(2020 - 1) == {436, 2020 - 1}
    end

    @part1_examples %{
      [1, 3, 2] => 1,
      [2, 1, 3] => 10,
      [1, 2, 3] => 27,
      [2, 3, 1] => 78,
      [3, 2, 1] => 438,
      [3, 1, 2] => 1836
    }
    for {start, expected} <- @part1_examples do
      test "starting with #{inspect(start)}, 2020th number is #{expected}" do
        assert RR.speak(unquote(start)) |> Enum.at(2020 - 1) == {unquote(expected), 2020 - 1}
      end
    end

    @part2_examples %{
      [0, 3, 6] => 175_594,
      [1, 3, 2] => 2578,
      [2, 1, 3] => 3_544_142,
      [1, 2, 3] => 261_214,
      [2, 3, 1] => 6_895_259,
      [3, 2, 1] => 18,
      [3, 1, 2] => 362
    }
    for {start, expected} <- @part2_examples do
      @tag :slow
      test "starting with #{inspect(start)}, 30.000.000th number is #{expected}" do
        assert RR.speak(unquote(start)) |> Enum.at(30_000_000 - 1) ==
                 {unquote(expected), 30_000_000 - 1}
      end
    end
  end
end
