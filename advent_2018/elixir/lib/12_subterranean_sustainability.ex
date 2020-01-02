defmodule SubterraneanSustainability do
  @moduledoc """
  December 12 - Subterranean Sustainability

  The problem can be found at https://adventofcode.com/2018/day/12
  1. Sum pot numbers for pots with plants after 20 generations?
  2. Sum pot numbers for pots with plants after 50_000_000_000 generations?
  """

  @input_file Path.join([__DIR__, "..", "inputs", "12.txt"])
  def part1(), do: part1(File.read!(@input_file))

  def part1(string) when is_binary(string) do
    string
    |> parse()
    |> run(20)
    |> sum_pot_numbers()
  end

  def part2(), do: part2(File.read!(@input_file))

  def part2(string) when is_binary(string) do
    string
    |> parse()
    |> find_repeated_pattern()
    |> fake_gen_50_billion()
    |> sum_pot_numbers()
  end

  @doc """
  Advances the state of pots a given number of generations

  ## Examples

      iex> @example_state.pots
      "#..#.#..##......###...###"
      iex> run(@example_state, 20).pots
      "#....##....#####...#######....#.#..##"
  """
  def run(state, 0), do: state

  def run(state, limit) do
    state |> tick() |> run(limit - 1)
  end

  @doc """
  Find a repeated pot configuration

  ## Examples

      iex> find_repeated_pattern(@example_state).generation
      87
  """
  def find_repeated_pattern(state, seen \\ MapSet.new()) do
    case Enum.member?(seen, state.pots) do
      true ->
        state

      false ->
        find_repeated_pattern(tick(state), MapSet.put(seen, state.pots))
    end
  end

  def fake_gen_50_billion(state) do
    offset_50b = 50_000_000_000 - state.generation + state.offset
    %{state | generation: 50_000_000_000, offset: offset_50b}
  end

  @doc """
  Advance the pots one generation by applying the supplied rules

  ## Examples

      iex> gen1 = tick(@example_state)
      iex> gen1.pots
      "#...#....#.....#..#..#..#"
      iex> gen1.generation
      1
  """
  @padding "...."
  def tick(state) do
    padded_pots = tick(@padding <> state.pots <> @padding, state.rules, _acc = "")
    {new_pots, offset_adjustment} = trim(padded_pots, -2)

    %{
      state
      | pots: new_pots,
        offset: state.offset + offset_adjustment,
        generation: state.generation + 1
    }
  end

  def trim(<<?#, _::binary>> = pots, offset_adjustment) do
    {String.trim_trailing(pots, "."), offset_adjustment}
  end

  def trim(<<?., rest::binary>>, offset_adjustment) do
    trim(rest, offset_adjustment + 1)
  end

  def tick(<<a, b, c, d, e, rest::binary>>, rules, acc) do
    tail = <<b, c, d, e, rest::binary>>
    key = <<a, b, c, d, e>>
    tick(tail, rules, acc <> <<Map.get(rules, key, ?.)>>)
  end

  def tick(_rest, _rules, acc), do: acc

  def sum_pot_numbers(%{pots: pots, offset: offset}) do
    numbered_pots = Enum.with_index(to_charlist(pots), offset)
    for {?#, i} <- numbered_pots, reduce: 0, do: (sum -> sum + i)
  end

  def parse(string) do
    [first_line | rule_lines] = String.split(string, "\n", trim: true)

    %{
      pots: initial_pots(first_line),
      offset: 0,
      generation: 0,
      rules: parse_rules(rule_lines)
    }
  end

  @rule_size 5
  def parse_rules(lines) do
    Enum.reduce(lines, %{}, fn line, map ->
      [<<pattern::binary-size(@rule_size)>>, <<result>>] = String.split(line, " => ")
      Map.put(map, pattern, result)
    end)
  end

  def initial_pots("initial state: " <> pots), do: pots

  def print(state) do
    IO.puts(
      "#{String.pad_leading(to_string(state.generation), 2)}: #{state.pots} - #{state.offset}"
    )

    state
  end
end
