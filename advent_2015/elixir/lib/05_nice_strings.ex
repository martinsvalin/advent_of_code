defmodule NiceStrings do
  @moduledoc """
  Day 5 - Doesn't He Have Intern-Elves For This?

  ## Solutions

      iex> File.read!("../input/05.txt") |> String.split() |> Enum.count(&NiceStrings.nice?/1)
      iex> File.read!("../input/05.txt") |> String.split() |> Enum.count(&NiceStrings.nicer?/1)

  """

  @doc """
  Is a string nice according to Santa's old rules?

  - It contains at least three vowels (aeiou only)
  - It contains at least one letter that appears twice in a row
  - It does not contain the strings ab, cd, pq, or xy
  """
  def nice?(string) do
    three_or_more_vowels?(string) && repeated_letter?(string) && no_disallowed_pair?(string)
  end

  @vowels 'aeiou'

  defp three_or_more_vowels?(string) do
    string |> to_charlist() |> Enum.count(&(&1 in @vowels)) >= 3
  end

  defp repeated_letter?(""), do: false
  defp repeated_letter?(<<same, same>> <> _), do: true
  defp repeated_letter?(<<_>> <> rest), do: repeated_letter?(rest)

  @disallowed_pair ['ab', 'cd', 'pq', 'xy']

  defp no_disallowed_pair?(string) do
    string
    |> pairs()
    |> Enum.all?(fn pair -> pair not in @disallowed_pair end)
  end

  defp pairs(string) do
    string
    |> to_charlist()
    |> Enum.chunk_every(2, 1, :discard)
  end

  @doc """
  Is a string nice according to Santa's new, improved rules?

  - It contains a pair of any two letters that appears at least twice in the string without overlapping
  - It contains at least one letter which repeats with exactly one letter between them
  """
  def nicer?(string) do
    recurring_pair?(string) && one_between?(string)
  end

  defp recurring_pair?(string) do
    string
    |> pairs()
    |> recurring?([])
  end

  defp recurring?([], _), do: false
  defp recurring?([h | t], []), do: recurring?(t, [h])

  defp recurring?([h | t], [_ | non_overlapping] = all) do
    case h in non_overlapping do
      true -> true
      false -> recurring?(t, [h | all])
    end
  end

  defp one_between?(""), do: false
  defp one_between?(<<same, _, same>> <> _), do: true
  defp one_between?(<<_>> <> rest), do: one_between?(rest)
end
