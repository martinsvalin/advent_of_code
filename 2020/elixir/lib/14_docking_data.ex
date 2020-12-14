defmodule DockingData do
  import Bitwise

  def run(lines) do
    lines
    |> parse()
    |> run(%{mask: {0, 0}, registers: %{}})
  end

  def run([], state), do: state.registers

  def run([{:mask, zeros, ones} | instructions], state) do
    run(instructions, %{state | mask: {zeros, ones}})
  end

  def run([{:mem, register, value} | instructions], state) do
    run(instructions, put_in(state, [:registers, register], mask(value, state.mask)))
  end

  def mask(value, {zeros, ones}) do
    (value ||| ones) &&& ~~~zeros
  end

  def parse(lines), do: Enum.map(lines, &parse_line/1)

  defp parse_line("mask = " <> mask) when byte_size(mask) == 36 do
    {zeros, ones} =
      mask
      |> String.codepoints()
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reduce({0, 0}, fn
        {"X", _}, acc -> acc
        {"0", power}, {zeros, ones} -> {zeros + :math.pow(2, power), ones}
        {"1", power}, {zeros, ones} -> {zeros, ones + :math.pow(2, power)}
      end)

    {:mask, trunc(zeros), trunc(ones)}
  end

  defp parse_line("mem" <> rest) do
    [register, value] =
      Regex.run(~r/\[(\d+)\] = (\d+)/, rest, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    {:mem, register, value}
  end
end
