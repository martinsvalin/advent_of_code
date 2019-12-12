defmodule AmplificationCircuitTest do
  use ExUnit.Case
  alias AmplificationCircuit, as: Day7

  @examples "07_test.txt"
            |> Util.file_contents()
            |> Util.lines()
            |> Enum.map(&Util.numbers/1)

  describe "part 1 puzzle examples" do
    test "example 1" do
      assert Day7.part1(example1_1()) == 43210
    end

    test "example 2" do
      assert Day7.part1(example1_2()) == 54321
    end

    test "example 3" do
      assert Day7.part1(example1_3()) == 65210
    end
  end

  describe "part 2 puzzle examples" do
    test "example 1" do
      assert Day7.part2(example2_1()) == 139_629_729
    end

    test "example 2" do
      assert Day7.part2(example2_2) == 18216
    end
  end

  describe "permutations/1" do
    test "it takes any enum" do
      assert Day7.permutations(1..2) == [[1, 2], [2, 1]]
      assert Day7.permutations(%{a: 1, b: 2}) == [[a: 1, b: 2], [b: 2, a: 1]]
      assert Day7.permutations(MapSet.new([1, 2])) == [[1, 2], [2, 1]]
    end

    test "empty list" do
      assert Day7.permutations([]) == [[]]
    end

    test "5 items has 120 permutations" do
      assert Day7.permutations(1..5) |> Enum.count() == 120
    end
  end

  defp example1_1(), do: Enum.at(@examples, 0)
  defp example1_2(), do: Enum.at(@examples, 1)
  defp example1_3(), do: Enum.at(@examples, 2)
  defp example2_1(), do: Enum.at(@examples, 3)
  defp example2_2(), do: Enum.at(@examples, 4)
end
