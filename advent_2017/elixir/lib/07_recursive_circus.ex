require IEx

defmodule RecursiveCircus do
  @moduledoc """
  Recursive circus - a tower of balancing programs

  We see a tower of balancing programs, with a single program at the bottom.
  Their names, weights and the names of those balancing on their disc is given
  as unordered input like this:

  pbga (66)
  xhth (57)
  ebii (61)
  havc (66)
  ktlj (57)
  fwft (72) -> ktlj, cntj, xhth
  qoyq (66)
  padx (45) -> pbga, havc, qoyq
  tknk (41) -> ugml, padx, fwft
  jptl (61)
  ugml (68) -> gyxo, ebii, jptl
  gyxo (61)
  cntj (57)

  1. What is the name of the program at the root?
  2. What should the unbalanced program weigh to balance up the tower?
  """

  @doc """
  Get the name of the program at the root
  """
  @spec root(String.t()) :: String.t()
  def root(input) do
    {all, all_above} =
      input
      |> lines()
      |> Enum.reduce({MapSet.new(), MapSet.new()}, fn
           {name, _, []}, {all, all_above} ->
             {MapSet.put(all, name), all_above}

           {name, _, above}, {all, all_above} ->
             {
               MapSet.put(all, name),
               Enum.reduce(above, all_above, fn child, set -> MapSet.put(set, child) end)
             }
         end)

    [root] = MapSet.difference(all, all_above) |> MapSet.to_list()
    root
  end

  @doc """
  The correct weight for the program that is making the tower unbalanced
  """
  @spec correct_weight(String.t()) :: integer
  def correct_weight(input) do
    input
    |> lines
    |> map_by_name
    |> build_tree(root(input))
    |> weigh_tree
    |> find_incorrect_weight
    |> suggest_correction
  end

  @doc false
  def map_by_name(lines) do
    Enum.reduce(lines, %{}, fn {name, weight, above}, map ->
      Map.put(map, name, {weight, above})
    end)
  end

  @doc false
  def build_tree(map, name) do
    {weight, above} = map[name]
    {name, weight, Enum.map(above, &build_tree(map, &1))}
  end

  @doc false
  def weigh_tree({name, own_weight, above}) do
    above_with_tree_weight = Enum.map(above, &weigh_tree/1)

    tree_weight =
      Enum.reduce(above_with_tree_weight, own_weight, fn {_, _, weight, _}, sum ->
        sum + weight
      end)

    {name, own_weight, tree_weight, above_with_tree_weight}
  end

  @doc false
  def find_incorrect_weight({name, weight, tree_weight, above}, balanced \\ []) do
    groups = Enum.group_by(above, &elem(&1, 2))

    case map_size(groups) do
      1 ->
        [{_, _, correct_weight, _} | _] = balanced
        {name, weight, tree_weight, correct_weight}

      2 ->
        {unbalanced, balanced} = extract_unbalanced_and_balanced(groups)
        find_incorrect_weight(unbalanced, balanced)

      _ ->
        raise ArgumentError, message: "there is more than a single unbalanced tree"
    end
  end

  @doc false
  def suggest_correction({_name, own_weight, wrong_weight, correct_weight}) do
    own_weight + correct_weight - wrong_weight
  end

  @doc false
  def extract_unbalanced_and_balanced(groups) do
    Enum.reduce(groups, {nil, nil}, fn {_, list}, {unbalanced, balanced} ->
      case length(list) do
        1 -> {hd(list), balanced}
        _ -> {unbalanced, list}
      end
    end)
  end

  @doc false
  @spec lines(String.t()) :: [{String.t(), integer, [String.t()]}]
  defp lines(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&line/1)
  end

  @line_regex ~r/^
    \s*                      # ignore leading whitespace
    (?<name>\w+)             # capture first word as name
    \s\((?<weight>\d+)\)     # capture weight inside parenthesis
    (\s->\s                  # ignore arrow
      (?<above>(\w+(,\s)?)+) # capture comma-separated names of one or more above
    )?                       # above are optional
    $/x

  @doc false
  @spec line(String.t()) :: {String.t(), integer, [String.t()]}
  def line(string) do
    %{"name" => name, "weight" => weight, "above" => above} =
      Regex.named_captures(@line_regex, string)

    case above do
      "" ->
        {name, String.to_integer(weight), []}

      above ->
        {name, String.to_integer(weight), String.split(above, ", ")}

      nil ->
        raise ArgumentError,
          message:
            "line must be of pattern 'name (weight) -> names, above' but was: #{inspect(line)}"
    end
  end
end
