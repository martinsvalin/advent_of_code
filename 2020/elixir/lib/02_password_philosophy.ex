defmodule PasswordPhilosophy do
  def count_valid_passwords_by_count(lines) do
    count_valid_passwords(lines, &valid_count?/1)
  end

  def count_valid_passwords_by_position(lines) do
    count_valid_passwords(lines, &valid_positions?/1)
  end

  defp count_valid_passwords(lines, policy) do
    lines |> parse |> Enum.count(policy)
  end

  defp parse(lines) when is_list(lines), do: Enum.map(lines, &parse/1)

  defp parse(line) when is_binary(line) do
    [_full, first, second, <<char::utf8>>, password] = Regex.run(~r/(\d+)-(\d+) (.): (.+)/, line)

    %{
      password: to_charlist(password),
      character: char,
      range: String.to_integer(first)..String.to_integer(second)
    }
  end

  defp valid_count?(%{character: char, range: range, password: password}) do
    Enum.count(password, &(&1 == char)) in range
  end

  defp valid_positions?(%{character: char, range: first..second, password: password}) do
    [first - 1, second - 1]
    |> Enum.map(&Enum.at(password, &1))
    |> Enum.count(&(char == &1)) == 1
  end
end
