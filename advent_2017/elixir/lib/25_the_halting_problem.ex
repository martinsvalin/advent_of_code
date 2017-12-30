defmodule HaltingProblem do
  @moduledoc """
  Dec 25 - The Halting Problem

  Build a Turing machine from a blueprint. The blueprint says what state to
  begin in, when to run a diagnostic checksum, and a description of how the
  machine behaves in different states.

  This behaviour is determined by the value of the current position on the
  tape. For each state and value, we have what value to write, which direction
  to move, and what state to continue in.

  See `TuringBlueprint` for specifics on the blueprint format.

  The checksum is performed by summing all the 1:s on the tape.

  1. What is the checksum of our Turing machine?
  """

  @doc "Return the checksum after running the machine for diagnostics"
  def checksum(input) do
    input
    |> TuringBlueprint.parse()
    |> run_diagnostics()
    |> Enum.sum()
  end

  @doc "Start the machine with a limit on the number of steps. Returns memory."
  def run_diagnostics(%{begin: start_state, diagnostic_steps: limit} = blueprint) do
    run(blueprint, {[], 0, []}, start_state, limit)
  end

  def run(_blueprint, {left, current, right}, _state, 0), do: left ++ [current | right]

  def run(blueprint, {left, current, right}, state, limit) do
    %{write: value, move: direction, continue: next_state} = blueprint[state][current]
    updated_memory = move({left, value, right}, direction)

    run(blueprint, updated_memory, next_state, limit - 1)
  end

  def move({[], current, right}, "left"), do: {[], 0, [current | right]}
  def move({left, current, []}, "right"), do: {[current | left], 0, []}
  def move({[head | left], current, right}, "left"), do: {left, head, [current | right]}
  def move({left, current, [head | right]}, "right"), do: {[current | left], head, right}
end

defmodule TuringBlueprint do
  @moduledoc """
  Parses a blueprint of a specific format

  An example of a valid blueprint is:

      Begin in state A.
      Perform a diagnostic checksum after 6 steps.
        
      In state A:
        If the current value is 0:
          - Write the value 1.
          - Move one slot to the right.
          - Continue with state B.
        If the current value is 1:
          - Write the value 0.
          - Move one slot to the left.
          - Continue with state B.

      In state B:
        If the current value is 0:
          - Write the value 1.
          - Move one slot to the left.
          - Continue with state A.
        If the current value is 1:
          - Write the value 1.
          - Move one slot to the right.
          - Continue with state A.

  This will be parsed into:

      %{
        :begin => "A",
        :diagnostic_steps => 6,
        "A" => %{
          0 => %{continue: "B", move: "right", write: 1},
          1 => %{continue: "B", move: "left", write: 0}
        },
        "B" => %{
          0 => %{continue: "A", move: "left", write: 1},
          1 => %{continue: "A", move: "right", write: 1}
        }
      }
  """

  @doc "Parses a string blueprint into a map representation"
  def parse(blueprint) do
    blueprint
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce({%{}, []}, &parse_line/2)
    |> elem(0)
  end

  defp parse_line("Begin in state " <> <<state::bytes-1>> <> ".", {acc, last}) do
    {Map.put(acc, :begin, state), last}
  end

  defp parse_line("Perform a diagnostic checksum after " <> n_steps, {acc, last}) do
    {steps, _rest} = Integer.parse(n_steps)
    {Map.put(acc, :diagnostic_steps, steps), last}
  end

  defp parse_line("In state " <> <<state::bytes-1>> <> ":", {acc, _}) do
    {Map.put(acc, state, %{}), [state]}
  end

  defp parse_line("If the current value is " <> <<value::bytes-1>> <> ":", {acc, [state | _]}) do
    current = [state, String.to_integer(value)]
    {put_in(acc, current, %{}), current}
  end

  defp parse_line("- Write the value " <> <<value::bytes-1>> <> ".", {acc, last}) do
    {put_in(acc, last ++ [:write], String.to_integer(value)), last}
  end

  defp parse_line("- Move one slot to the " <> direction, {acc, last}) do
    {put_in(acc, last ++ [:move], String.trim_trailing(direction, ".")), last}
  end

  defp parse_line("- Continue with state " <> <<state::bytes-1>> <> ".", {acc, last}) do
    {put_in(acc, last ++ [:continue], state), last}
  end

  defp parse_line(_, acc), do: acc
end
