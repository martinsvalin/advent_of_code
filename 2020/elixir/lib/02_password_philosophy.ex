defmodule PasswordPhilosophy do
  def count_valid_passwords(lines) do
    lines
    |> parse
    |> character_frequency
    |> Enum.count(&valid_for_part1?/1)
  end

  defp parse(lines) when is_list(lines), do: Enum.map(lines, &parse/1)

  defp parse(line) when is_binary(line) do
    [_full, first, last, <<char::utf8>>, password] = Regex.run(~r/(\d+)-(\d+) (.): (.+)/, line)

    %{
      password: password,
      character: char,
      range: String.to_integer(first)..String.to_integer(last)
    }
  end

  defp character_frequency(list) when is_list(list), do: Enum.map(list, &character_frequency/1)

  defp character_frequency(%{password: password} = map) do
    Map.put_new(map, :frequencies, password |> to_charlist() |> Enum.frequencies())
  end

  defp valid_for_part1?(%{character: char, range: range, frequencies: frequencies}) do
    frequencies[char] in range
  end
end
