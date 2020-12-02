defmodule PasswordPhilosophy do
  def count_valid_passwords_by_frequency(lines) do
    lines
    |> parse
    |> character_frequency
    |> Enum.count(&valid_frequencies?/1)
  end

  def count_valid_passwords_by_position(lines) do
    lines |> parse |> Enum.count(&valid_positions?/1)
  end

  defp parse(lines) when is_list(lines), do: Enum.map(lines, &parse/1)

  defp parse(line) when is_binary(line) do
    [_full, first, last, <<char::utf8>>, password] = Regex.run(~r/(\d+)-(\d+) (.): (.+)/, line)

    %{
      password: to_charlist(password),
      character: char,
      range: String.to_integer(first)..String.to_integer(last)
    }
  end

  defp character_frequency(list) when is_list(list), do: Enum.map(list, &character_frequency/1)

  defp character_frequency(%{password: password} = map) do
    Map.put_new(map, :frequencies, password |> Enum.frequencies())
  end

  defp valid_frequencies?(%{character: char, range: range, frequencies: frequencies}) do
    frequencies[char] in range
  end

  defp valid_positions?(%{character: char, range: first..second, password: password}) do
    [Enum.at(password, first - 1), Enum.at(password, second - 1)]
    |> Enum.count(&(&1 == char)) == 1
  end
end
