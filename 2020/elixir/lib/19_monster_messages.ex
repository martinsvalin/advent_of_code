defmodule MonsterMessages do
  import Advent2020, only: [lines: 1]

  def modify_rules(%{rules: rules} = map) do
    %{map | rules: modify_rules(rules)}
  end

  def modify_rules(rules) do
    rules
    |> Map.put(8, [[42, 8], [42]])
    |> Map.put(11, [[42, 11, 31], [42, 31]])
  end

  ## Matching

  def match?(message, rules) do
    IO.inspect({message, rules}, label: "Start matching")
    {:ok, ""} == match?(message, rules, rules[0])
  end

  def match?({:ok, message}, rules, rule) when is_binary(message) do
    match?(message, rules, rule)
  end

  def match?("a" <> rest, _rules, "a"), do: {:ok, rest}
  def match?("b" <> rest, _rules, "b"), do: {:ok, rest}

  def match?(message, _rules, rule) when is_binary(rule) and is_binary(message) do
    {:error, message}
  end

  def match?(message, rules, [alt1, alt2])
      when is_list(alt1) and is_list(alt2) and is_binary(message) do
    IO.inspect({message, {alt1, alt2}}, label: "Rule has 2 alternatives", charlists: :as_lists)

    case match?(message, rules, alt1) do
      {:error, _} ->
        IO.puts(
          "Alt 1 failed: #{inspect(alt1, charlists: :as_lists)}. Will try Alt 2: #{
            inspect(alt2, charlists: :as_lists)
          }"
        )

        match?(message, rules, alt2)

      {:ok, rest} ->
        IO.puts("Alt 1 succeed: #{inspect(alt1, charlists: :as_lists)}")
        {:ok, rest}
    end
  end

  def match?(message, rules, [binary | _] = binaries) when is_binary(binary) do
    IO.puts("Matching #{length(binaries)} binary alternatives.")

    Enum.find_value(
      binaries,
      {:error, message},
      fn binary ->
        case match?(message, rules, binary) do
          {:ok, rest} -> {:ok, rest}
          {:error, _} -> false
        end
      end
    )
  end

  def match?(message, rules, [list]) when is_list(list), do: match?(message, rules, list)

  def match?(message, _rules, []) when is_binary(message) do
    {:ok, message}
  end

  def match?(message, rules, [rule | list]) when is_binary(message) do
    IO.inspect({message, rule}, label: "Matching rule #{rule}")

    case match?(message, rules, rules[rule]) do
      {:error, msg} ->
        IO.puts("Rule #{rule} failed. Won't try rest: #{inspect(list, charlists: :as_lists)}")
        {:error, msg}

      {:ok, rest} ->
        IO.puts("Rule #{rule} succeed. Will try rest: #{inspect(list, charlists: :as_lists)}")
        match?(rest, rules, list)
    end
  end

  ## Parsing

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
