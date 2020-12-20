defmodule TicketTranslation do
  def scanning_error(input) when is_binary(input), do: scanning_error(Advent2020.lines(input))

  def scanning_error(lines) when is_list(lines) do
    parsed = parse(lines)

    parsed.nearby_tickets
    |> Enum.flat_map(&invalid(&1, parsed.rules))
    |> Enum.sum()
  end

  def determine_fields(input) when is_binary(input), do: determine_fields(Advent2020.lines(input))

  def determine_fields(lines) when is_list(lines) do
    parsed = parse(lines)
    valid_nearby = Enum.filter(parsed.nearby_tickets, &(invalid(&1, parsed.rules) == []))

    fields =
      valid_nearby
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.with_index()

    parsed.rules
    |> Enum.to_list()
    |> mark_possible(fields)
    |> solve(%{})
  end

  def mark_possible(rules, fields, possible \\ %{})

  def mark_possible([], _, possible), do: possible

  def mark_possible([{name, {low, high}} | rules], fields, possible) do
    possible_fields =
      for {field, i} <- fields,
          Enum.all?(field, &(&1 in low || &1 in high)),
          do: i

    mark_possible(rules, fields, Map.put(possible, name, possible_fields))
  end

  def solve(possible, fixed) when map_size(possible) == map_size(fixed) do
    fixed |> Enum.sort() |> Enum.map(&elem(&1, 1))
  end

  def solve(possible, fixed) do
    new_possible =
      Map.new(possible, fn {fieldname, candidates} ->
        {fieldname, Enum.reject(candidates, &(Map.get(fixed, &1, fieldname) != fieldname))}
      end)

    new_fixed = for {k, [i]} <- new_possible, into: Map.new(), do: {i, k}

    solve(new_possible, new_fixed)
  end

  def invalid(ticket, rules) do
    Enum.reject(ticket, fn n -> Enum.any?(collect_rules(rules), fn range -> n in range end) end)
  end

  def collect_rules(rules) when is_map(rules) do
    rules |> Map.values() |> Enum.flat_map(&Tuple.to_list/1)
  end

  ## Parsing

  def parse(lines, part \\ :rules, out \\ %{rules: %{}})

  def parse([], :nearby_tickets, out) do
    %{out | nearby_tickets: Enum.reverse(out.nearby_tickets)}
  end

  def parse(["" | lines], part, out), do: parse(lines, part, out)

  def parse(["your ticket:" | lines], :rules, out), do: parse(lines, :your_ticket, out)

  def parse(["nearby tickets:" | lines], :your_ticket, out) do
    parse(lines, :nearby_tickets, Map.put(out, :nearby_tickets, []))
  end

  def parse([rule | lines], :rules, %{rules: rules} = out) do
    parse(lines, :rules, %{out | rules: add_rule(rules, rule)})
  end

  def parse([ticket | lines], :your_ticket, out) do
    parse(lines, :your_ticket, Map.put(out, :your_ticket, ticket(ticket)))
  end

  def parse([ticket | lines], :nearby_tickets, %{nearby_tickets: near} = out) do
    parse(lines, :nearby_tickets, %{out | nearby_tickets: [ticket(ticket) | near]})
  end

  defp ticket(raw_ticket) do
    raw_ticket |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  defp add_rule(rules, rule) do
    [name | numbers] =
      Regex.run(~r/([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)/, rule, capture: :all_but_first)

    [low_first, low_last, high_first, high_last] = Enum.map(numbers, &String.to_integer/1)

    Map.put(rules, name, {low_first..low_last, high_first..high_last})
  end
end
