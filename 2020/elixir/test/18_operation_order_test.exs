defmodule OperationOrderTest do
  use ExUnit.Case

  @examples [
    "1 + 2 * 3 + 4 * 5 + 6",
    "1 + (2 * 3) + (4 * (5 + 6))",
    "2 * 3 + (4 * 5)",
    "5 + (8 * 3 + 9 + 3 * 4 * 3)",
    "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
    "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"
  ]

  describe "do_homework/1" do
    @answers [71, 51, 26, 437, 12240, 13632]

    for {line, expected} <- Enum.zip(@examples, @answers) do
      test "calculates expression: #{line}" do
        assert OperationOrder.do_homework([unquote(line)]) == unquote(expected)
      end
    end

    test "sums the calculations" do
      assert OperationOrder.do_homework(@examples) == Enum.sum(@answers)
    end
  end

  describe "do_advanced_homework/1" do
    @answers [231, 51, 46, 1445, 669_060, 23340]

    for {line, expected} <- Enum.zip(@examples, @answers) do
      test "calculates expression: #{line}" do
        assert OperationOrder.do_advanced_homework([unquote(line)]) == unquote(expected)
      end
    end

    test "sums the calculations" do
      assert OperationOrder.do_advanced_homework(@examples) == Enum.sum(@answers)
    end
  end
end
