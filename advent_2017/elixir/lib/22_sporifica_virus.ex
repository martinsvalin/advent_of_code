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
  def virus_infections(input, bursts, evolved \\ false) do
    input
    |> new()
    |> count_infections(bursts, evolved)
  end

  @doc false
  def new(input) do
    %__MODULE__{nodes: parse_initial_nodes(input), current: center(input)}
  end

  @doc false
  def count_infections(%{infections: infections}, 0, _), do: infections

  def count_infections(state, bursts, evolved) do
    new_state =
      state
      |> turn(evolved)
      |> toggle(evolved)
      |> move()

    count_infections(new_state, bursts - 1, evolved)
  end

  @doc false
  def turn(state, false) do
    case state_of_current_node(state) do
      :clean -> do_turn(state, :left)
      :infected -> do_turn(state, :right)
    end
  end

  def turn(state, true) do
    case state_of_current_node(state) do
      :clean -> do_turn(state, :left)
      :weakened -> state
      :infected -> do_turn(state, :right)
      :flagged -> do_turn(state, :back)
    end
  end

  @doc false
  def do_turn(%{direction: :up} = state, :left), do: %{state | direction: :left}
  def do_turn(%{direction: :left} = state, :left), do: %{state | direction: :down}
  def do_turn(%{direction: :down} = state, :left), do: %{state | direction: :right}
  def do_turn(%{direction: :right} = state, :left), do: %{state | direction: :up}

  def do_turn(%{direction: :up} = state, :right), do: %{state | direction: :right}
  def do_turn(%{direction: :left} = state, :right), do: %{state | direction: :up}
  def do_turn(%{direction: :down} = state, :right), do: %{state | direction: :left}
  def do_turn(%{direction: :right} = state, :right), do: %{state | direction: :down}

  def do_turn(%{direction: :up} = state, :back), do: %{state | direction: :down}
  def do_turn(%{direction: :left} = state, :back), do: %{state | direction: :right}
  def do_turn(%{direction: :down} = state, :back), do: %{state | direction: :up}
  def do_turn(%{direction: :right} = state, :back), do: %{state | direction: :left}

  @doc false
  def toggle(state, false) do
    case state_of_current_node(state) do
      :clean -> infect(state)
      :infected -> clean(state)
    end
  end

  def toggle(state, true) do
    case state_of_current_node(state) do
      :clean -> weaken(state)
      :weakened -> infect(state)
      :infected -> flag(state)
      :flagged -> clean(state)
    end
  end

  defp clean(state), do: %{state | nodes: Map.put(state.nodes, state.current, :clean)}
  defp weaken(state), do: %{state | nodes: Map.put(state.nodes, state.current, :weakened)}
  defp flag(state), do: %{state | nodes: Map.put(state.nodes, state.current, :flagged)}

  defp infect(state) do
    %{
      state
      | nodes: Map.put(state.nodes, state.current, :infected),
        infections: state.infections + 1
    }
  end

  defp state_of_current_node(state) do
    Map.get(state.nodes, state.current, :clean)
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
