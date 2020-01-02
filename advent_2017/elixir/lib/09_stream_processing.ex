defmodule StreamProcessing do
  @moduledoc """
  Day 9 - Stream Processing

  The problem can be found at https://adventofcode.com/2017/day/9
  We're looking at a part of a stream of nested garbage groups. A stream contains
  groups of garbage. The groups are delimited by curly braces. Garbage is delimited
  by angle brackets. Exclamation mark escapes the following character.

  Groups are scored. The outermost group is scored one. Nested groups are scored
  one more than its parent group.

  1. What is the total score of the part of the stream we're looking at?
  """

  @type tree :: [tree] | garbage
  @type scored_tree :: {pos_integer, tree} | garbage
  @type garbage :: binary

  @doc """
  Give the total score for input, for part 1

  ## Examples

      iex> score("{}")
      1
      iex> score("{{<ab>},{<ab>},{<ab>},{<ab>}}")
      9
  """
  @spec score(String.t()) :: pos_integer()
  def score(input) do
    input
    |> String.trim_trailing()
    |> parse_into_tree
    |> assign_scores
    |> total_score
  end

  @doc """
  Count the combined length of the garbage, ignoring escaped characters

  ## Examples

      iex> garbage_length("{<abc>,<d>}")
      4
      iex> garbage_length("{<!b>}")
      0
  """
  @spec garbage_length(String.t()) :: non_neg_integer()
  def garbage_length(input) do
    input
    |> String.trim_trailing()
    |> parse_into_tree()
    |> List.flatten()
    |> Enum.map(&byte_size/1)
    |> Enum.sum()
  end

  @doc """
  Parse the stream into a tree structure

  Curly braces delimit groups that contain comma-separated groups or garbage
  Angle brackets delimit garbage. Exclamation points escape characters in
  garbage. Escaped characters are removed.

  ## Examples

      iex> parse_into_tree("{{<ab>},{{<cd!>,<ef>},{}}}")
      [["ab"],[["cd,<ef"], []]]
  """
  @spec parse_into_tree(String.t()) :: tree
  def parse_into_tree(string), do: hd(parse_into_tree(string, [], false))

  defp parse_into_tree("", tree, _), do: tree
  defp parse_into_tree("}" <> rest, tree, false), do: {Enum.reverse(tree), rest}

  defp parse_into_tree("{" <> rest, tree, false) do
    {group, more_rest} = parse_into_tree(rest, [], false)
    parse_into_tree(more_rest, [group | tree], false)
  end

  defp parse_into_tree("," <> rest, tree, false), do: parse_into_tree(rest, tree, false)

  defp parse_into_tree("<" <> rest, tree, false) do
    parse_into_tree(rest, ["" | tree], true)
  end

  defp parse_into_tree(">" <> rest, tree, true) do
    parse_into_tree(rest, tree, false)
  end

  defp parse_into_tree(<<"!", _::utf8>> <> rest, tree, true) do
    parse_into_tree(rest, tree, true)
  end

  defp parse_into_tree(<<char::utf8>> <> rest, [gb | tree], true) do
    parse_into_tree(rest, [gb <> <<char::utf8>> | tree], true)
  end

  @doc """
  Assign scores to each node in the tree, starting with 1

  ## Examples

      iex> assign_scores([["ab"], []])
      {1, [{2, ["ab"]}, {2, []}]}
  """
  @spec assign_scores(tree) :: scored_tree
  def assign_scores(tree, initial_score \\ 1)
  def assign_scores(garbage, _) when is_binary(garbage), do: garbage

  def assign_scores(tree, score) when is_list(tree) do
    {score, Enum.map(tree, fn sub_tree -> assign_scores(sub_tree, score + 1) end)}
  end

  @doc """
  Sum the scores in the tree

  ## Examples

      iex> total_score({1, [{2, ["ab"]}]})
      3
  """
  @spec total_score(scored_tree) :: pos_integer()
  def total_score({score, scored_tree}) do
    Enum.reduce(scored_tree, score, fn subtree, sum -> sum + total_score(subtree) end)
  end

  def total_score(_), do: 0
end
