defmodule Spinlock do
  @moduledoc """
  Dec 17 - Spinlock

  A whirling, pixelated hurricane is spinning a circular list of numbers,
  inserting a new value on every iteration. Starting from only holding a
  zero spins a given length, and inserts 1, then spins the same length
  and inserts 2, etc up to 2017.

  1. What is the value after 2017 in the list?
  """

  @doc """
  Return the value after 2017, given a spin length

  ## Examples

      iex> Spinlock.value_after_2017(3)
      638
  """
  def value_after_2017(spin_length) do
    {index, list} =
      1..2017
      |> Enum.reduce({0, [0]}, fn i = len, {current, list} ->
           next = rem(current + spin_length, len) + 1
           {next, List.insert_at(list, next, i)}
         end)

    Enum.at(list, index + 1)
  end
end
