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
    |> Enum.find(fn candidate -> bingo(candidate, prefix_size) end)
    |> elem(0)
  end

  defp bingo({_n, digest}, prefix_size) do
    digest
    |> String.starts_with?(String.duplicate("0", prefix_size))
  end

  defp candidates(key) do
    all_numbers
    |> Stream.map(fn (n) -> {n, md5(key, n)} end)
  end

  defp all_numbers do
    Stream.iterate(1, &(&1 + 1))
  end

  defp md5(key, n) do
    key <> Integer.to_string(n)
    |> :erlang.md5
    |> Base.encode16
  end
end

defmodule Answer do
  @doc """
  Check that our solution is correct by asserting against known answers to given
  input.

  ## Examples
      iex> Answer.check :part1, "abcdef", 609_043
      :ok
      iex> Answer.check :part1, "pqrstuv", 1_048_970
      :ok
      iex> Answer.check :part2, "abcdef", 609_043
      :ok
      ** (RuntimeError) Wrong answer. Expected 609043, got 6742839
  """
  def check(:part1, input, expected), do: assert(AdventCoin.mine(input, 5), expected)
  def check(:part2, input, expected), do: assert(AdventCoin.mine(input, 6), expected)

  defp assert(actual, expected) do
    case actual do
      ^expected -> :ok
      _ ->  raise "Wrong answer. Expected #{expected}, got #{actual}"
    end
  end
end

tasks = [
  Task.async(fn -> Answer.check :part1, "abcdef", 609_043 end),
  Task.async(fn -> Answer.check :part1, "pqrstuv", 1_048_970 end)
]

my_key = "yzbqklnj"
part1 = Task.async(fn -> AdventCoin.mine(my_key, 5) end) |> Task.await
part2 = Task.async(fn -> AdventCoin.mine(my_key, 6) end) |> Task.await(50_000)
IO.puts "AdventCoin with five leading zeroes found at #{part1} for #{my_key}."
IO.puts "AdventCoin with six leading zeroes found at #{part2} for #{my_key}."

tasks |> Enum.map(&Task.await/1)
IO.puts "Checks pass"
