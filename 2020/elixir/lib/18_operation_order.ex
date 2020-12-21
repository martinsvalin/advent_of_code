defmodule DifferentMath do
  def a <|> b, do: a + b
  def a <~> b, do: a * b
end

defmodule OperationOrder do
  def do_homework(lines) do
    Enum.map(lines, &calculate_expression/1) |> Enum.sum()
  end

  def do_advanced_homework(lines) do
    Enum.map(lines, &calculate_expression(&1, [{"*", "<~>"}])) |> Enum.sum()
  end

  def calculate_expression(line, replacements \\ [{"+", "<|>"}, {"*", "<~>"}]) do
    Enum.reduce(replacements, line, fn {original, replacement}, string ->
      String.replace(string, original, replacement)
    end)
    |> Code.eval_string([], functions: [{DifferentMath, [<|>: 2, <~>: 2]}, {Kernel, [+: 2]}])
    |> elem(0)
  end
end
