defmodule InverseCaptcha do
  @moduledoc """
  December 1 – Inverse Captcha

  The problem can be found at http://adventofcode.com/2017/day/1
  1. Find the sum of all digits that match the next digit in the list
  2. Find the sum of all digits that match the one half a list away
  """

  @doc """
  Find the sum of all digits that match the next digit in the list

  The list is circular, such that the last digit is followed by the first.

  ## Examples

      iex> sum_matching_next("1122")
      3
      iex> sum_matching_next("1111")
      4
  """
  def sum_matching_next(digits = [hd | tl]) when is_list(digits) do
    rotate_one = tl ++ [hd]

    digits
    |> Enum.zip(rotate_one)
    |> sum_matching
  end

  def sum_matching_next(digits) when is_binary(digits) do
    digits |> String.codepoints() |> sum_matching_next
  end

  @doc """
  Find the sum of all digits that match the one half a list away

  The list is circular, such that the last digit has the middle digit across.

  ## Examples

      iex> sum_matching_across("1212")
      6
      iex> sum_matching_across("1221")
      0
  """
  def sum_matching_across(digits) when is_list(digits) do
    half = length(digits) |> div(2)
    across = Enum.drop(digits, half) ++ Enum.take(digits, half)

    digits
    |> Enum.zip(across)
    |> sum_matching
  end

  def sum_matching_across(digits) when is_binary(digits) do
    digits |> String.codepoints() |> sum_matching_across
  end

  defp sum_matching(pairs) do
    Enum.reduce(pairs, 0, fn
      {x, x}, sum -> sum + String.to_integer(x)
      _, sum -> sum
    end)
  end
end
