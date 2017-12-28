defmodule SporificaVirus do
  @moduledoc """
  Dec 22 - Sporifica Virus

  A virus is walking a computing grid, infecting and cleaning nodes as it goes.
  It keeps track of direction, starting facing up. On each burst, it turns left
  if the current node is clean, right if it is infected. It then toggles the
  state of the node, and moves forward.

  Given the starting state below (clean nodes are dots, infected are hashes),
  and the virus starting at the center position:

      . . #
      # . .
      . . .

  The virus turns left (node is clean), infects it, moves forward. Repeat this
  70 times, and the virus will have caused an infection 41 times.

  1. How many times has the virus caused an infection after 10 000 bursts?

  Evolved, the virus will not just toggle between infected/clean, instead:
  Clean nodes become weakened. Weakened nodes become infected. Infected nodes
  become flagged. Flagged nodes become clean.

  It also has new rules for turning:
  If it is clean, it turns left.
  If it is weakened, it does not turn.
  If it is infected, it turns right.
  If it is flagged, it reverses direction.

  2. How many times has the virus caused an infection after 10 million bursts?
  """

  defstruct nodes: %{},
            current: {0, 0},
            direction: :up,
            infections: 0

  @doc """
  Return the number of infections for a given number of bursts.
  """
  def virus_infections(input, bursts) do
    input
    |> new()
    |> count_infections(bursts)
  end

  @doc false
  def new(input) do
    %__MODULE__{nodes: parse_initial_nodes(input), current: center(input)}
  end

  @doc false
  def count_infections(%{infections: infections}, 0), do: infections

  def count_infections(state, bursts) do
    new_state =
      state
      |> turn()
      |> toggle()
      |> move()

    count_infections(new_state, bursts - 1)
  end

  @doc false
  def turn(state) do
    case Map.get(state.nodes, state.current, :clean) do
      :infected -> turn(state, :right)
      :clean -> turn(state, :left)
    end
  end

  @doc false
  def turn(%{direction: :up} = state, :left), do: %{state | direction: :left}
  def turn(%{direction: :left} = state, :left), do: %{state | direction: :down}
  def turn(%{direction: :down} = state, :left), do: %{state | direction: :right}
  def turn(%{direction: :right} = state, :left), do: %{state | direction: :up}

  def turn(%{direction: :up} = state, :right), do: %{state | direction: :right}
  def turn(%{direction: :left} = state, :right), do: %{state | direction: :up}
  def turn(%{direction: :down} = state, :right), do: %{state | direction: :left}
  def turn(%{direction: :right} = state, :right), do: %{state | direction: :down}

  @doc false
  def toggle(state) do
    case Map.get(state.nodes, state.current, :clean) do
      :infected ->
        %{state | nodes: Map.put(state.nodes, state.current, :clean)}

      :clean ->
        %{
          state |
          nodes: Map.put(state.nodes, state.current, :infected),
          infections: state.infections + 1
        }
    end
  end

  @doc false
  def move(%{direction: :up, current: {i, j}} = state), do: %{state | current: {i - 1, j}}
  def move(%{direction: :left, current: {i, j}} = state), do: %{state | current: {i, j - 1}}
  def move(%{direction: :down, current: {i, j}} = state), do: %{state | current: {i + 1, j}}
  def move(%{direction: :right, current: {i, j}} = state), do: %{state | current: {i, j + 1}}

  @doc false
  def parse_initial_nodes(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, i}, set ->
         row
         |> Enum.with_index()
         |> Enum.reduce(set, fn
              {"#", j}, acc -> Map.put(acc, {i, j}, :infected)
              _, acc -> acc
            end)
       end)
  end

  @doc false
  def center(input) do
    lines = String.split(input, "\n", trim: true)

    {
      lines |> length() |> div(2),
      lines |> hd() |> String.length() |> div(2)
    }
  end
end
