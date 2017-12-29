defmodule CoprocessorConflagration do
  @moduledoc """
  Dec 23 - Coprocessor Conflagration

  An experimental coprocessor is running instructions similar to the ones
  from Dec 18 - Duet. The operations are:

      set X Y  - set register X to value of Y
      sub X Y  - decreases register X by the value of Y
      mul X Y  - multiplies register X by the value of Y
      jnz X Y  - jumps with offset of value of Y, if register X has non-zero value

  Registers go from `a` to `h`, and begin at zero.

  1. How many times is the `mul` operation invoked?

  Setting register `a` to `1` disables debug mode. The program, however, is
  very inefficient.

  2. What is the final value of the `h` register?
  """

  defstruct left: [], right: [], register: %{}, muls: 0

  def count_mul_ops(input) do
    input
    |> new()
    |> run()
    |> Map.get(:muls)
  end

  @doc """
  Run until limit (or finish) and get what's in register h

  We can manipulate some of the registers in the input to experiment.
  Stepping through iterations and inspecting state also proved very
  useful in reverse engineering.
  """
  def whats_in_h(input, limit) do
    input
    |> new()
    |> toggle_debug_mode()
    |> run(limit)
    |> Map.get(:register)
    |> Map.get("h", 0)
  end

  def new(input), do: %__MODULE__{right: ops(input)}

  defp toggle_debug_mode(state) do
    set(state, "a", "1")
  end

  # Set limit to a negative number for unlimited runs
  defp run(state, limit \\ -1)
  defp run(state, 0) do
    IO.inspect(register: state.register, op: hd(state.right))
    state
  end
  defp run(%{right: []} = state, _), do: state

  defp run(%{right: [op | _]} = state, limit) do
    case op do
      {:set, x, y} -> set(state, x, y) |> forward |> run(limit - 1)
      {:sub, x, y} -> sub(state, x, y) |> forward |> run(limit - 1)
      {:mul, x, y} -> mul(state, x, y) |> forward |> run(limit - 1)
      {:jnz, x, y} -> jump(state, x, y) |> forward |> run(limit - 1)
    end
  end

  defp set(%{register: reg} = state, x, y) do
    %{state | register: Map.put(reg, x, val(reg, y))}
  end

  defp sub(%{register: reg} = state, x, y) do
    %{state | register: Map.put(reg, x, val(reg, x) - val(reg, y))}
  end

  defp mul(%{register: reg} = state, x, y) do
    %{state | register: Map.put(reg, x, val(reg, x) * val(reg, y)), muls: state.muls + 1}
  end

  defp jump(%{register: reg} = state, x, y) do
    case val(reg, x) do
      0 ->
        state

      _ ->
        {left, right} = move(state.left, state.right, val(reg, y) - 1)
        %{state | left: left, right: right}
    end
  end

  defp move(left, right, 0), do: {left, right}

  defp move(left, right, n) when n < 0 do
    {right, left} = move(right, left, -n)
    {left, right}
  end

  defp move(left, [head | tail], n) do
    move([head | left], tail, n - 1)
  end

  defp forward(%{left: left, right: [head | tail]} = state) do
    %{state | left: [head | left], right: tail}
  end

  defp val(reg, key) do
    case Integer.parse(key) do
      {n, ""} -> n
      :error -> Map.get(reg, key, 0)
    end
  end

  defp ops(input) do
    Regex.scan(~r/[\w-]+/, input)
    |> parse([])
  end

  def parse([], ops), do: Enum.reverse(ops)
  def parse([["set"], [x], [y] | rest], ops), do: parse(rest, [{:set, x, y} | ops])
  def parse([["sub"], [x], [y] | rest], ops), do: parse(rest, [{:sub, x, y} | ops])
  def parse([["mul"], [x], [y] | rest], ops), do: parse(rest, [{:mul, x, y} | ops])
  def parse([["jnz"], [x], [y] | rest], ops), do: parse(rest, [{:jnz, x, y} | ops])
end
