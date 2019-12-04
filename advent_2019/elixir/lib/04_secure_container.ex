defmodule SecureContainer do
  @moduledoc """
  # Day 4: Secure Container

  https://adventofcode.com/2019/day/4

  A six-digit password has the following hints: the digits are same or increasing
  (meaning a 5 can be followed by 5-9, but not 0-4), and there is at least one
  pair of neighbouring, repeated digits, like 11 in 112345.

  We also know that the password is within a given range (the puzzle input).

  ## Part 1: How many possible passwords are there in the given range?

  ## Part 2: How many, if double digits can not part of a larger group?

  I.e. 112345 is valid, but 111234 is not even though it was for part 1.
  """

  def part1(range) do
    length(generate_passwords(range, &repeat?/1))
  end

  def part2(range) do
    length(generate_passwords(range, &pair?/1))
  end

  @doc "Generate password candidates with increasing digits that fit the criteria"
  def generate_passwords(first..last = range, criteria) do
    for a <- div(first, 100_000)..div(last, 100_000),
        b <- a..9,
        c <- b..9,
        d <- c..9,
        e <- d..9,
        f <- e..9,
        n = a * 100_000 + b * 10_000 + c * 1000 + d * 100 + e * 10 + f,
        n in range,
        criteria.([a, b, c, d, e, f]),
        do: n
  end

  @doc """
  # Check that a number has a repeated neighbouring digit

  Used as criteria for generate_passwords/2 in Part 1.

  ## Examples

      iex> repeat?([1,1,2,3,4,5])
      true

      iex> repeat?([1,2,3,4,5,6])
      false

      iex> repeat?([1,1,1,1,1,1])
      true
  """
  def repeat?([a, a | _]), do: true
  def repeat?([_, b | t]), do: repeat?([b | t])
  def repeat?(_), do: false

  @doc """
  # Check for a pair of same digits not part of a larger group

  Used as criteria for generate_passwords/2 in Part 2.

  ## Examples

      iex> pair?([1,1,2,3,4,5])
      true

      iex> pair?([1,1,1,1,2,2])
      true

      iex> pair?([1,1,1,1,1,1])
      false
  """
  def pair?(list) do
    Enum.chunk_by(list, & &1) |> Enum.any?(&(length(&1) == 2))
  end
end
