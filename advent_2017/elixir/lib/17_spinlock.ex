defmodule Spinlock do
  @moduledoc """
  Dec 17 - Spinlock

  A whirling, pixelated hurricane is spinning a circular list of numbers,
  inserting a new value on every iteration. Starting from only holding a
  zero spins a given length, and inserts 1, then spins the same length
  and inserts 2, etc up to 2017.

  1. What is the value after 2017 in the list?
  2. What is the value after 0 when the spinlock has spun 50 million times?
  """

  @doc """
  Return the value after last inserted value, given spin length and number of spins

  ## Examples

      iex> Spinlock.value_after_last_inserted(3, 2017)
      638
  """
  def value_after_last_inserted(spin_length, max) do
    {index, list} =
      1..max
      |> Enum.reduce({0, [0]}, fn i = len, {current, list} ->
           next = rem(current + spin_length, len) + 1
           {next, List.insert_at(list, next, i)}
         end)

    Enum.at(list, index + 1)
  end

  @doc """
  Return the value after 0, given spin length and number of spins

  ## Examples

      iex> Spinlock.value_after_0(3, 50_000)
      38_713
  """
  def value_after_0(spin_length, max) do
    value_after_0(0, nil, spin_length, 0, 1, max + 1)
  end

  def value_after_0(_, value_after_zero, _, _, max, max), do: value_after_zero

  def value_after_0(index_of_zero, value_after_zero, spin, current, val = len, max) do
    next_index = rem(current + spin, len) + 1

    case next_index - index_of_zero do
      1 ->
        value_after_0(index_of_zero, val, spin, next_index, val + 1, max)

      x when x < 1 ->
        value_after_0(index_of_zero + 1, value_after_zero, spin, next_index, val + 1, max)

      x when x > 1 ->
        value_after_0(index_of_zero, value_after_zero, spin, next_index, val + 1, max)
    end
  end
end
