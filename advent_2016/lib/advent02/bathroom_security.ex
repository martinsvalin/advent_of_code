defmodule Advent.BathroomSecurity do
  @moduledoc """
  # Advent of Code, Day 2: Bathroom Security

  See: http://adventofcode.com/2016/day/2
  """

  @doc """
  Decode the bathroom code from instructions to move on a 3x3 keypad.

  ## Examples

      iex> decode("ULL\\nRRDDD\\nLURDL\\nUUUUD")
      "1985"
  """
  @spec decode(String.t) :: String.t
  def decode(instructions) do
    instructions
    |> decode(5, [])
    |> Enum.reverse
    |> Enum.join
  end

  defp decode("", key, code), do: [key | code]
  defp decode("\n" <> rest, key, code), do: decode(rest, key, [key | code])

  defp decode("U" <> rest, key, code) when key in [1,2,3], do: decode(rest, key, code)
  defp decode("U" <> rest, key, code), do: decode(rest, key - 3, code)

  defp decode("D" <> rest, key, code) when key in [7,8,9], do: decode(rest, key, code)
  defp decode("D" <> rest, key, code), do: decode(rest, key + 3, code)

  defp decode("L" <> rest, key, code) when key in [1,4,7], do: decode(rest, key, code)
  defp decode("L" <> rest, key, code), do: decode(rest, key - 1, code)

  defp decode("R" <> rest, key, code) when key in [3,6,9], do: decode(rest, key, code)
  defp decode("R" <> rest, key, code), do: decode(rest, key + 1, code)
end
