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
  Calculate total severity of moving at time 0.
  """
  @spec total_severity(String.t()) :: non_neg_integer()
  def total_severity(input, delay \\ 0) do
    scanners = input |> to_map
    last_depth = Map.keys(scanners) |> Enum.max()

    0..last_depth
    |> Enum.zip(delay..(last_depth + delay))
    |> Enum.map(&severity(scanners, &1))
    |> Enum.sum()
  end

  defp severity(scanners, {depth, time}) do
    case scanners[depth] do
      nil -> 0
      range -> (rem(time, (range - 1) * 2) == 0 && range * depth) || 0
    end
  end

  defp to_map(string) do
    Regex.scan(~r/(\d+): (\d+)/, string)
    |> Enum.map(fn [_, depth, range] -> {String.to_integer(depth), String.to_integer(range)} end)
    |> Map.new()
  end
end
