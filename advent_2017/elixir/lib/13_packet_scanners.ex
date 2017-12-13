defmodule PacketScanners do
  @moduledoc """
  Dec 13 - Packet Scanners

  Security scanners at different depths are sweeping up and down. They each have a range, and sweep one step vertically
  every picosecond. We move at the top, one step forward every picosecond. We move first, then scanner sweeps.

  If we enter a depth while it is scanning at the top, we are caught. The severity of being caught is the product of the
  scanner's depth and range. We are not caught if we enter and the scanner then sweeps into the top.

  1. What is the total severity if we start moving immediately (i.e. go into depth 0 at time 0)
  """

  @doc """
  Calculate total severity of moving with a given delay (default delay is zero)
  """
  @spec total_severity(String.t()) :: non_neg_integer()
  def total_severity(input, delay \\ 0) do
    for {depth, range} <- scanners(input), caught_at?(range, depth + delay) do
      depth * range
    end
    |> Enum.sum
  end

  @doc """
  Find the best delay when you can pass through the scanners without being caught
  """
  def sneaky_time(input), do: sneaky_time(scanners(input), 0)

  defp sneaky_time(scanners, delay) do
    caught? = Enum.any?(scanners, fn {depth, range} -> caught_at?(range, depth + delay) end)
    case caught? do
      true -> sneaky_time(scanners, delay + 1)
      false -> delay
    end
  end

  defp caught_at?(range, time), do: rem(time, (range - 1) * 2) == 0

  defp scanners(string) do
    Regex.scan(~r/(\d+): (\d+)/, string)
    |> Map.new(fn [_, depth, range] -> {String.to_integer(depth), String.to_integer(range)} end)
  end
end
