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
    {scanners, max_depth} = parse(input)

    total_severity(scanners, max_depth, delay)
  end

  defp total_severity(scanners, max_depth, delay) do
    severities(scanners, max_depth, delay)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  @doc """
  Find the best delay when you can pass through the scanners without being caught
  """
  def sneaky_time(input) do
    {scanners, max_depth} = parse(input)

    sneaky_time(scanners, max_depth, 0)
  end

  defp sneaky_time(scanners, max_depth, delay) do
    undetected =
      severities(scanners, max_depth, delay)
      |> Enum.all?(&(elem(&1, 0) == :undetected))

    case undetected do
      true -> delay
      _ -> sneaky_time(scanners, max_depth, delay + 1)
    end
  end

  @doc """
  The severity of getting caught for each step when starting at a given delay
  """
  @spec severities(map(), non_neg_integer(), non_neg_integer()) :: [
          {:caught | :undetected, non_neg_integer()}
        ]
  def severities(scanners, max_depth, delay) do
    0..max_depth
    |> Enum.zip(delay..(max_depth + delay))
    |> Enum.map(&severity(scanners, &1))
  end

  @doc """
  The severity of getting caught at a given depth and time. Zero if we're not caught at that time.
  """
  @spec severity(map(), {non_neg_integer(), non_neg_integer()}) ::
          {:caught | :undetected, non_neg_integer()}
  def severity(scanners, {depth, time}) do
    range = scanners[depth]

    if caught?(range, time), do: {:caught, range * depth}, else: {:undetected, 0}
  end

  defp caught?(nil, _time), do: false
  defp caught?(range, time), do: rem(time, (range - 1) * 2) == 0

  defp parse(string) do
    scanners =
      Regex.scan(~r/(\d+): (\d+)/, string)
      |> Enum.map(fn [_, depth, range] -> {String.to_integer(depth), String.to_integer(range)} end)
      |> Map.new()

    {scanners, Map.keys(scanners) |> Enum.max()}
  end
end
