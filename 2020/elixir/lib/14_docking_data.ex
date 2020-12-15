defmodule DockingData do
  import Bitwise

  def run(lines, version \\ :v1)

  def run(lines, :v1) do
    lines |> parse() |> run_v1(%{mask: {0, 0}, registers: %{}})
  end

  def run(lines, :v2) do
    lines |> parse() |> run_v2(%{mask: {0, 0, []}, registers: %{}})
  end

  def run_v1([], state), do: state.registers

  def run_v1([{:mask, zeros, ones, _} | instructions], state) do
    run_v1(instructions, %{state | mask: {zeros, ones}})
  end

  def run_v1([{:mem, register, value} | instructions], state) do
    run_v1(instructions, put_in(state, [:registers, register], mask(value, state.mask)))
  end

  def run_v2([], state), do: state.registers

  def run_v2([{:mask, _, ones, xs} | instructions], state) do
    run_v2(instructions, %{state | mask: {ones, xs}})
  end

  def run_v2([{:mem, register, value} | instructions], state) do
    run_v2(instructions, %{state | registers: write_to_registers(state, register, value)})
  end

  def write_to_registers(%{mask: {ones, xs}, registers: registers}, register, value) do
    masks_from_xs(xs, ones)
    |> Enum.reduce(registers, fn mask, map ->
      Map.put(map, mask(register, mask), value)
    end)
  end

  def masks_from_xs(xs, ones) do
    zeros =
      Enum.reduce(xs, [0], fn power, list ->
        n = :math.pow(2, power) |> trunc()
        Enum.map(list, &(&1 + n)) ++ list
      end)
      |> Enum.sort()

    Enum.zip(zeros, Enum.reverse(zeros) |> Enum.map(&(&1 + ones)))
  end

  def mask(value, {zeros, ones}) do
    (value ||| ones) &&& ~~~zeros
  end

  def parse(lines), do: Enum.map(lines, &parse_line/1)

  defp parse_line("mask = " <> mask) when byte_size(mask) == 36 do
    {zeros, ones, xs} =
      mask
      |> String.codepoints()
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reduce({0, 0, []}, fn
        {"0", power}, {zeros, ones, xs} -> {zeros + :math.pow(2, power), ones, xs}
        {"1", power}, {zeros, ones, xs} -> {zeros, ones + :math.pow(2, power), xs}
        {"X", power}, {zeros, ones, xs} -> {zeros, ones, [power | xs]}
      end)

    {:mask, trunc(zeros), trunc(ones), xs}
  end

  defp parse_line("mem" <> rest) do
    [register, value] =
      Regex.run(~r/\[(\d+)\] = (\d+)/, rest, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    {:mem, register, value}
  end
end
