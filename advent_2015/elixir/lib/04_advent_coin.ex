defmodule AdventCoin do
  @moduledoc """
  Mine AdventCoin by finding the lowest number producing an MD5 with leading
  zeroes when combined with the input key. The number of leading zeroes can
  be specified, but defaults to five.
  """

  @doc """
  Find the lowest number that, combined with key, produces an MD5 hexdigest with
  `prefix_size` leading zeroes.

  ## Examples

      iex> AdventCoin.mine("abcdef")
      609043
      iex> AdventCoin.mine("abcdef", 6)
      6742839
  """
  def mine(key, prefix_size \\ 5) do
    key
    |> candidates
    |> Enum.find_value(fn candidate -> bingo(candidate, prefix_size) end)
  end

  defp bingo({n, digest}, prefix_size) do
    if String.starts_with?(digest, String.duplicate("0", prefix_size)), do: n
  end

  defp candidates(key) do
    all_numbers()
    |> Stream.map(fn (n) -> {n, md5(key, n)} end)
  end

  defp all_numbers do
    Stream.iterate(1, &(&1 + 1))
  end

  defp md5(key, n) do
    key <> Integer.to_string(n)
    |> :erlang.md5()
    |> Base.encode16()
  end
end
