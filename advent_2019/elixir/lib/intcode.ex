defmodule Intcode do
  @moduledoc """
  # Intcode interpreter

  Used for the following puzzles:
  - https://adventofcode.com/2019/day/2
  - https://adventofcode.com/2019/day/5

  Intcode is represented as comma-separated integers. The first integer of a
  group is the instruction, followed by its parameters. Once the instruction
  is run, the instruction pointer moves forward to the next instruction.

  ## Instructions

    1: Addition, three parameters:
        - left hand side operand
        - right hand side operand
        - where sum should be stored
    2: Multiplication, three paramterers:
        - left hand side operand
        - right hand side operand
        - where product should be stored
    3: Input, one parameter:
        - where to store input
    4: Output, one parameter:
        - value to output
    5: Jump if true, two parameters:
        - condition, true if non-zero
        - destination to set position to
    6: Jump if false, two parameters:
        - condition, true if zero
        - destination to set position to
    7: Less than, three parameters:
        - left hand side operand
        - right hand side operand
        - where to write result of comparison, 1 for less-than, 0 otherwise
    8: Equals, three parameters:
        - left hand side operand
        - right hand side operand
        - where to write result of comparison, 1 for equals, 0 otherwise
    9: Adjust relative base, one parameter:
        - adjustment to add to relative base
    99: Exit program, no parameters.

  ## Parameter modes

  Instructions operate in one of three modes: position mode, where parameters are
  the address of its value; immediate mode, where parameters are the values
  themselves; relative mode, where the parameters are the address of its value,
  offset by the relative base (defaulted to 0, but can be adjusted).

  Parameter mode is given with the instruction, such that the two least
  significant digits represent the instruction (01 for addition, for instance),
  and the mode of each of its parameters, in order of least significant digit.

  As an example, 1101 is an addition instruction where both operands are given
  in immediate mode, and the third parameter is in position mode (leading zeroes
  are not given, but are implicitly there).

  Writes can not be in immediate mode.
  """

  defstruct code: %{}, position: 0, inputs: [], outputs: [], relative_base: 0
  alias __MODULE__, as: I

  @type state() :: %I{}
  @type position() :: non_neg_integer()

  @doc "Run Intcode program, using given list of inputs for input instructions"
  @spec run([integer()], [integer()]) :: state()
  def run(list, inputs) when is_list(list) do
    load(list, inputs) |> run()
  end

  @spec run([integer()]) :: state()
  @doc "Run Intcode program and return the state on termination"
  def run(list) when is_list(list) do
    load(list) |> run()
  end

  @spec run(state()) :: state()
  def run(%I{code: code, position: pos} = state) when is_map(state) do
    case instruction(read(code, pos)) do
      # Addition
      {1, modes} ->
        [lhs, rhs, write_to] = positions(3, state, pos, modes)
        state |> write(write_to, read(code, lhs) + read(code, rhs)) |> advance(4) |> run()

      # Multiplication
      {2, modes} ->
        [lhs, rhs, write_to] = positions(3, state, pos, modes)
        state |> write(write_to, read(code, lhs) * read(code, rhs)) |> advance(4) |> run()

      # Input
      {3, [mode]} ->
        case take_input(state) do
          :none ->
            {:waiting, state}

          {new_state, input} ->
            new_state |> write(position(state, pos + 1, mode), input) |> advance(2) |> run()
        end

      # Output
      {4, [mode]} ->
        value = read(code, position(state, pos + 1, mode))
        state |> output(value) |> advance(2) |> run()

      # Jump if true
      {5, modes} ->
        [condition, destination] = positions(2, state, pos, modes)

        if(read(code, condition) == 0) do
          state |> advance(3) |> run()
        else
          state |> jump(read(code, destination)) |> run()
        end

      # Jump if false
      {6, modes} ->
        [condition, destination] = positions(2, state, pos, modes)

        if(read(code, condition) == 0) do
          state |> jump(read(code, destination)) |> run()
        else
          state |> advance(3) |> run()
        end

      # Less than
      {7, modes} ->
        [lhs, rhs, write_to] = positions(3, state, pos, modes)
        val = if(read(code, lhs) < read(code, rhs), do: 1, else: 0)
        state |> write(write_to, val) |> advance(4) |> run()

      # Equals
      {8, modes} ->
        [lhs, rhs, write_to] = positions(3, state, pos, modes)
        val = if(read(code, lhs) == read(code, rhs), do: 1, else: 0)
        state |> write(write_to, val) |> advance(4) |> run()

      {9, [mode]} ->
        adjustment = read(code, position(state, pos + 1, mode))
        adjust_relative_base(state, adjustment) |> advance(2) |> run()

      # Terminate
      {99, _} ->
        state

      # Unknown
      _ ->
        raise ArgumentError, message: "invalid program"
    end
  end

  @spec read(map(), position()) :: integer()
  def read(code, position) do
    Map.get(code, position, 0)
  end

  @spec write(state(), position(), integer()) :: state()
  def write(state, pos, value) do
    %{state | code: Map.put(state.code, pos, value)}
  end

  @spec advance(state(), integer()) :: state()
  def advance(state, steps) do
    %{state | position: state.position + steps}
  end

  @spec jump(state(), position()) :: state()
  def jump(state, pos) do
    %{state | position: pos}
  end

  @spec output(state(), integer()) :: state()
  def output(%I{outputs: outs} = state, out) do
    %{state | outputs: [out | outs]}
  end

  @spec input(state(), integer()) :: state()
  def input(%I{inputs: inputs} = state, value) do
    %{state | inputs: [value | inputs]}
  end

  @spec take_input(state()) :: {state(), integer()}
  def take_input(%I{inputs: []}) do
    :none
  end

  def take_input(%I{inputs: [head | tail]} = state) do
    {%{state | inputs: tail}, head}
  end

  @spec adjust_relative_base(state(), integer()) :: state()
  def adjust_relative_base(%I{relative_base: relbase} = state, adjustment) do
    %{state | relative_base: relbase + adjustment}
  end

  @spec load([integer()], [integer()]) :: state()
  def load(list, inputs \\ []) when is_list(list) do
    %I{code: to_code(list), inputs: inputs}
  end

  @spec to_code([integer()]) :: map()
  def to_code(program) do
    for {value, i} <- Enum.with_index(program), into: %{}, do: {i, value}
  end

  def instruction(instruction) when is_integer(instruction) do
    {rem(instruction, 100), modes(div(instruction, 100))}
  end

  def modes(number, acc \\ [])
  def modes(number, modes) when number < 10, do: Enum.reverse([number | modes])

  def modes(number, modes) when number >= 10 do
    modes(div(number, 10), [rem(number, 10) | modes])
  end

  @spec positions(non_neg_integer(), state(), position(), [integer()]) :: [position()]
  def positions(arity, state, position, modes, acc \\ [])
  def positions(0, _, _, _, acc), do: Enum.reverse(acc)

  def positions(n, state, pos, [mode | modes], acc) do
    positions(n - 1, state, pos + 1, modes, [position(state, pos + 1, mode) | acc])
  end

  def positions(n, state, pos, [], acc) do
    positions(n - 1, state, pos + 1, [], [position(state, pos + 1) | acc])
  end

  @spec position(state(), position(), integer()) :: position()
  def position(%I{code: code} = state, position, mode \\ 0) do
    case mode do
      2 -> state.relative_base + read(code, position)
      1 -> position
      0 -> read(code, position)
    end
  end

  def print_output(%I{outputs: outputs}) do
    outputs
    |> Enum.reverse()
    |> Enum.map(fn {p, val} -> IO.puts("Position: #{p}, value: #{val}") end)
  end
end
