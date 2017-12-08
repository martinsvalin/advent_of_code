defmodule LikeRegisters do
  @moduledoc """
  Day 8 – I Heard You Like Registers

  We get register based instructions like this, that are evaluated in turn:

      b inc 5 if a > 1
      a inc 1 if b < 5
      c dec -10 if a >= 1
      c inc -20 if c == 10

  All registers have zero as their value when we start.

  1. What is the max value of any register when we're done?
  2. What is the max value seen during evaluation?
  """

  @line_regex ~r/^
  \s* (\w+)    # register name
  \s (inc|dec) # operation
  \s (-?\d+)   # amount
  \s if \s
  (.*)         # condition
  $/mx

  @doc """
  Evaluate the register operations and return registers and their values
  """
  @spec eval(String.t()) :: map()
  def eval(input) do
    Regex.scan(@line_regex, input)
    |> Enum.reduce({%{}, 0}, &eval_line/2)
  end

  def max_after(input) do
    input
    |> eval
    |> elem(0)
    |> Map.values()
    |> Enum.max()
  end

  def max_during(input) do
    input |> eval |> elem(1)
  end

  defp eval_line([_full, name, op, amount, condition], {map, max}) do
    new_map =
      if eval_condition(condition, map) do
        eval_op(op, name, String.to_integer(amount), map)
      else
        Map.merge(%{name => 0}, map)
      end

    {new_map, max(max, new_map[name])}
  end

  defp eval_condition(full_condition, acc) do
    [_, left, comparison, right] = Regex.run(~r/(\w+) (\S+) (-?\d+)/, full_condition)
    eval_condition(left, comparison, String.to_integer(right), acc)
  end

  defp eval_condition(left, "==", right, acc), do: Map.get(acc, left, 0) == right
  defp eval_condition(left, "!=", right, acc), do: Map.get(acc, left, 0) != right
  defp eval_condition(left, "<=", right, acc), do: Map.get(acc, left, 0) <= right
  defp eval_condition(left, "<", right, acc), do: Map.get(acc, left, 0) < right
  defp eval_condition(left, ">=", right, acc), do: Map.get(acc, left, 0) >= right
  defp eval_condition(left, ">", right, acc), do: Map.get(acc, left, 0) > right

  defp eval_op("inc", name, amount, acc), do: Map.update(acc, name, amount, &(&1 + amount))
  defp eval_op("dec", name, amount, acc), do: Map.update(acc, name, -amount, &(&1 - amount))
end
