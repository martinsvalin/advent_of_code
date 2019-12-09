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
        - Address or value of left hand side operand
        - Address or value of right hand side operand
        - Address where their sum should be stored
    2: Multiplication, three paramterers:
        - Address or value of left hand side operand
        - Address or value of right hand side operand
        - Address where their product should be stored
    3: Input, one parameter:
        - Address of where to store input
    4: Output, one parameter:
        - Address of where to store output
    99: Exit program, no parameters.

  ## Parameter modes

  Instructions operate in one of two modes: position mode, where parameters are
  the address of its value, and immediate mode, where parameters are the values
  themselves.

  Parameter mode is given with the instruction, such that the two least
  significant digits represent the instruction (01 for addition, for instance),
  and the mode of each of its parameters, in order of least significant digit.

  As an example, 1101 is an addition instruction where both operands are given
  in immediate mode, and the third parameter is in position mode (leading zeroes
  are not given, but are implicitly there).
  """

  defstruct code: %{}, position: 0, inputs: [], outputs: []
  alias __MODULE__, as: I

  @type state() :: %I{}
  @type position() :: non_neg_integer()

  @doc "Run Intcode program, using given list of inputs for input instructions"
  @spec run([integer()], [integer()]) :: state()
  def run(list, inputs) when is_list(list) do
    run(%I{code: to_code(list), inputs: inputs})
  end

  @spec run([integer()]) :: state()
  @doc "Run Intcode program and return the state on termination"
  def run(list) when is_list(list) do
    run(%I{code: to_code(list)})
  end

  @spec run(%I{}) :: state()
  def run(%I{code: code, position: pos} = state) when is_map(state) do
    case instruction(Map.fetch!(code, pos)) do
      {1, modes} ->
        [lhs, rhs] = values(2, code, pos, modes)
        run(%{state | code: Map.put(code, code[pos + 3], lhs + rhs), position: pos + 4})

      {2, modes} ->
        [lhs, rhs] = values(2, code, pos, modes)
        run(%{state | code: Map.put(code, code[pos + 3], lhs * rhs), position: pos + 4})

      {3, _} ->
        run(%{
          state
          | code: Map.put(code, code[pos + 1], hd(state.inputs)),
            position: pos + 2,
            inputs: tl(state.inputs)
        })

      {4, [mode]} ->
        run(%{
          state
          | position: pos + 2,
            outputs: [{pos, value(code, pos + 1, mode)} | state.outputs]
        })

      {99, _} ->
        state

      _ ->
        raise ArgumentError, message: "invalid program"
    end
  rescue
    KeyError -> raise ArgumentError, message: "invalid program"
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

  def values(arity, code, position, modes, acc \\ [])
  def values(0, _, _, _, acc), do: Enum.reverse(acc)

  def values(n, code, pos, [mode | modes], acc) do
    values(n - 1, code, pos + 1, modes, [value(code, pos + 1, mode) | acc])
  end

  def values(n, code, pos, [], acc) do
    values(n - 1, code, pos + 1, [], [value(code, pos + 1, 0) | acc])
  end

  def value(code, position, mode \\ 0) do
    case mode do
      1 -> code[position]
      0 -> code[code[position]]
    end
  end

  def print_output(%I{outputs: outputs}) do
    outputs
    |> Enum.reverse()
    |> Enum.map(fn {p, val} -> IO.puts("Position: #{p}, value: #{val}") end)
  end
end
