defmodule MonsterMessages do
  import Advent2020, only: [lines: 1]

  def match?(message, rules) do
    {:ok, ""} == match?(message, rules, rules[0])
  end

  def match?({:ok, message}, rules, rule) when is_binary(message) do
    match?(message, rules, rule)
  end

  def match?(<<rule::bytes-1>> <> rest, _rules, rule) when is_binary(rule) do
    {:ok, rest}
  end

  def match?(message, _rules, rule)
      when is_binary(rule) and is_binary(message),
      do: :error

  def match?(message, rules, [alt1, alt2])
      when is_list(alt1) and is_list(alt2) and is_binary(message) do
    case match?(message, rules, alt1) do
      :error -> match?(message, rules, alt2)
      {:ok, rest} -> {:ok, rest}
    end
  end

  def match?(message, rules, [list]) when is_list(list), do: match?(message, rules, list)

  def match?(message, rules, list) when is_binary(message) do
    Enum.reduce_while(list, message, fn rule, remaining_message ->
      case match?(remaining_message, rules, rules[rule]) do
        :error -> {:halt, :error}
        {:ok, rest} -> {:cont, {:ok, rest}}
      end
    end)
  end

  # Parsing

  def parse(input) do
    [raw_rules, raw_messages] = String.split(input, "\n\n")
    %{rules: Map.new(lines(raw_rules), &parse_rule/1), messages: lines(raw_messages)}
  end

  def parse_rule(line) do
    [rule_name | raw_groups] = String.split(line, [": ", " | "])

    value =
      case raw_groups do
        [<<?", char, ?">>] ->
          <<char>>

        _ ->
          Enum.map(raw_groups, fn group ->
            group |> String.split(" ") |> Enum.map(&String.to_integer/1)
          end)
      end

    {String.to_integer(rule_name), value}
  end
end
