defmodule InverseCaptcha do
  @moduledoc """
  December 1 – Inverse Captcha

  The problem can be found at http://adventofcode.com/2017/day/1
  Find the sum of all digits that match the next digit in the list

  """

  @doc """
  Find the sum of all digits that match the next digit in the list

  The list is circular, such that the last digit is followed by the first

  ## Examples

      iex> sum_matching_next([1,1,2,2])
      3
      iex> sum_matching_next([1,1,1,1])
      4

      iex> sum_matching_next("1122")
      3
      iex> sum_matching_next("1111")
      4
  """
  def sum_matching_next(digits = [hd|_]) when is_list(digits) do
    digits ++ [hd]
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [x,y] -> x == y end)
    |> Enum.reduce(0, fn [x, _], sum -> sum + x end)
  end
  def sum_matching_next(digits) when is_binary(digits) do
    digits |> to_numbers |> sum_matching_next
  end


  defp to_numbers(digits) when is_binary(digits) do
    digits |> String.to_integer |> Integer.digits
  end
end
