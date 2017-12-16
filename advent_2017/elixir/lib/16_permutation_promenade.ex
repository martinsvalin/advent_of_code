defmodule PermutationPromenade do
  @moduledoc """
  Dec 16 - Permutation Promenade

  We see a sequence of named programs dance. These are the dance moves:

  - Spin, written sX, moves X programs from the end to the front, preserving order.
  - Exchange, written xA/B, swaps programs at positions A and B
  - Partner, written pA/B, swaps programs named A and B

  1. What is the sequence after going through all the dance moves?
  2. What is the sequence after repeating the dance a billion times?
  """

  @doc """
  Returns sequence after performing dance moves

  ## Examples

      iex> dance(moves("s1,x3/4,pe/b"), 'abcde')
      'baedc'
  """
  def dance(moves, sequence) do
    Enum.reduce(moves, sequence, &perform_move/2)
  end

  @doc """
  Return the sequence after a given number of repetitions of the same dance moves

  ## Examples

      iex> repeat_dance("s1,x3/4,pe/b", 'abcde', 2)
      'ceadb'
      iex> repeat_dance("s1,x3/4,pe/b", 'abcde', 1_000_000_000)
      'abcde'
  """
  def repeat_dance(input, sequence, repetitions) do
    moves = moves(input)
    sequence = Enum.to_list(sequence)
    unique = unique(moves, sequence)

    case rem(repetitions, unique) do
      0 ->
        sequence

      upper ->
        1..upper
        |> Enum.reduce(sequence, fn _, seq ->
             dance(moves, seq)
           end)
    end
  end

  @doc """
  Returns the number of times we can repeat the dance until we are back to the initial state

  ## Examples

      iex> unique(moves("s1,x3/4,pe/b"), 'abcde')
      4
  """
  def unique(moves, sequence) do
    acc = {sequence, MapSet.new([sequence])}

    natural_numbers()
    |> Enum.reduce_while(acc, fn i, {seq, set} ->
         next_seq = dance(moves, seq)

         case MapSet.member?(set, next_seq) do
           true -> {:halt, i}
           false -> {:cont, {next_seq, MapSet.put(set, next_seq)}}
         end
       end)
  end

  @doc """
  Parses input into a keyword list of moves

  ## Examples

      iex> moves("s1,x3/4,pe/b")
      [spin: 1, exchange: {3,4}, partner: {?e, ?b}]
  """
  def moves(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse_move/1)
  end

  @doc false
  def parse_move(<<?s, n::binary>>), do: {:spin, String.to_integer(n)}

  def parse_move(<<?x, a::binary-1, ?/, b::binary>>),
    do: {:exchange, {String.to_integer(a), String.to_integer(b)}}

  def parse_move(<<?x, a::binary-2, ?/, b::binary>>),
    do: {:exchange, {String.to_integer(a), String.to_integer(b)}}

  def parse_move(<<?p, a::utf8, ?/, b::utf8>>), do: {:partner, {a, b}}

  @doc false
  def perform_move({move, arg}, seq), do: apply(__MODULE__, move, [seq, arg])

  @doc """
  Spin moves n elements from the end to the front of the list, preserving order

  ## Examples

      iex> spin('abcde', 1)
      'eabcd'
  """
  def spin(seq, n) do
    k = length(seq) - n
    Enum.drop(seq, k) ++ Enum.take(seq, k)
  end

  @doc """
  Swap elements at indices a and b

  ## Examples

      iex> exchange('abcde', {3, 4})
      'abced'
  """
  def exchange(seq, {a, b}) do
    partner(seq, {Enum.at(seq, a), Enum.at(seq, b)})
  end

  @doc """
  Swap elements a and b

  ## Examples

      iex> partner('abcde', {?b, ?e})
      'aecdb'
  """
  def partner(seq, {a, b}) do
    Enum.map(seq, fn
      ^a -> b
      ^b -> a
      x -> x
    end)
  end

  @doc false
  def natural_numbers, do: Stream.iterate(1, &(&1 + 1))
end
