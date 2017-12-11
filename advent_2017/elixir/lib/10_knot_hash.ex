defmodule KnotHash do
  @moduledoc """
  Dec 10 - Knot Hash

  A circular list repeatedly has parts of it reversed, based on input.
  The result forms the basis of the hash.

  1. What is the product of the first two numbers after tying the knots?
  """

  require Bitwise
  @standard_length_suffix [17, 31, 73, 47, 23]

  @doc """
  Perform simple hashing on a ring of a given size

  Input is a string of comma-separated numbers that give the lengths. These are
  the lengths used to obtain a `sparse_hash`. The result is the product of the
  first two elements in the sparse hash.

  ## Examples

      iex> KnotHash.simple_hash("3,4,1,5", 0..4)
      12
  """
  def simple_hash(input, ring) do
    [first, second | _] =
      input
      |> to_indexed_integers
      |> sparse_hash(ring)

    first * second
  end

  @doc """
  Perform the real knot hash, on a ring of 0..255

  Input is a string of ASCII characters, representing lengths by their ASCII value.
  These lengths are suffixed by the standard knot hash suffix. These lengths are then
  given as input to `sparse_hash` 64 times, preserving current position and skip size.

  The ring is then turned into a `dense_hash` by combining groups of 16 values with XOR.
  The resulting values are joined up as hexadecimal strings.

  ## Examples

      iex> KnotHash.real_hash("AoC 2017")
      "33efeb34ea91902bb2f59c9920caa6cd"
  """
  def real_hash(input) do
    (to_charlist(input) ++ @standard_length_suffix)
    |> List.duplicate(64)
    |> List.flatten()
    |> sparse_hash(0..255)
    |> dense_hash()
    |> to_hex_string()
  end

  @doc """
  Returns a ring that's been partially reversed multiple times

  Input is list of lengths, all below the ring size. For each length, reverse part of
  the ring of that length, then traverse the length plus a skip size that is increased
  with each iteration, starting at 0.

  ## Examples

      iex> KnotHash.sparse_hash([3,4,1,5], 0..4)
      [3,4,2,1,0]
  """
  def sparse_hash(lengths, ring) do
    indexed_lengths = Enum.with_index(lengths)

    indexed_lengths
    |> Enum.reduce(ring, &reverse_and_rotate/2)
    |> reset_rotation(indexed_lengths)
  end

  @doc """
  Returns the dense hash of a sparse hash, XORing each block of 16 values

  ## Examples

      iex> ring = [9, 20, 30, 11, 15, 16, 2, 12, 24, 26, 17, 27, 28, 31, 1, 22]
      iex> KnotHash.dense_hash(ring)
      [5]
  """
  def dense_hash(ring, acc \\ [])
  def dense_hash([], acc), do: Enum.reverse(acc)

  def dense_hash(ring, acc) do
    block = Enum.take(ring, 16)
    condensed_block = Enum.reduce(block, fn n, result -> Bitwise.bxor(n, result) end)
    dense_hash(Enum.drop(ring, 16), [condensed_block | acc])
  end

  defp reverse_and_rotate({length, skip}, list) do
    reverse = list |> Enum.take(length) |> Enum.reverse()
    rotate(reverse ++ Enum.drop(list, length), length + skip)
  end

  defp reset_rotation(ring, lengths) do
    ring_size = Enum.count(ring)
    rotations = Enum.reduce(lengths, 0, fn {length, skip}, sum -> sum + length + skip end)
    reset = ring_size - rem(rotations, ring_size)

    rotate(ring, reset)
  end

  defp rotate(ring, length) do
    l = rem(length, length(ring))
    Enum.drop(ring, l) ++ Enum.take(ring, l)
  end

  defp to_indexed_integers(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp to_hex_string(numbers) do
    numbers
    |> Enum.map(fn n ->
         n
         |> Integer.to_string(16)
         |> String.pad_leading(2, "0")
       end)
    |> Enum.join()
    |> String.downcase()
  end
end
