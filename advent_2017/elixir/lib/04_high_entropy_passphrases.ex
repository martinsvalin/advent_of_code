defmodule HighEntropyPassphrases do
  def valid?(phrase, fun \\ &(&1)) do
    phrase
    |> String.split
    |> frequency(fun)
    |> Enum.all?(fn {_, count} -> count == 1 end)
  end

  defp frequency(words, fun) do
    Enum.reduce(words, %{}, fn word, freq ->
      Map.update(freq, fun.(word), 1, & &1 + 1)
    end)
  end

  def for_anagram(word) do
    String.graphemes(word) |> Enum.sort |> Enum.join
  end
end