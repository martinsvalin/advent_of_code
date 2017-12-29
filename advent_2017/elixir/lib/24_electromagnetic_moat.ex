defmodule ElectromagneticMoat do
  @moduledoc """
  Dec 24 - Electromagnetic Moat

  We need to build the strongest possible bridge over to the CPU. We have a
  number of magnetic components that can plug into each other. Plugs need to
  match up, and components can only be used once. The bridge must start with
  a 0-type plug.

  Components are given as for example `0/7`, which represents a component
  with a 0-type plug on one side, and a 7-type plug on the other. You can
  turn components either way.

  The strength of a bridge is the sum of the port types of each component.
  For example, the bridge 0/1--10/1--9/10 has strength 31.

  1. What is the strongest bridge we can build?
  """

  @type bridge :: [component]
  @type component :: {{component_port, component_port}, index}
  @type component_port :: non_neg_integer
  @type index :: non_neg_integer

  @doc """
  What is the strength of the strongest bridge we can build from the components
  """
  @spec strongest_bridge(String.t()) :: non_neg_integer
  def strongest_bridge(input) do
    input
    |> components()
    |> possible_bridges()
    |> Enum.map(&bridge_strength/1)
    |> Enum.max()
  end

  def longest_bridge(input) do
    input
    |> components()
    |> possible_bridges()
    |> Enum.sort_by(&(-bridge_strength(&1)))
    |> Enum.max_by(&length/1)
    |> bridge_strength()
  end

  @doc """
  Returns all possible bridges we can build from the current bridge

  ## Examples

      iex> possible_bridges([{{0, 1}, 0}, {{4, 1}, 1}, {{1, 2}, 2}])
      [
        [{{1, 2}, 2}, {{0, 1}, 0}],
        [{{4, 1}, 1}, {{0, 1}, 0}],
        [{{0, 1}, 0}],
        []
      ]
  """
  @spec possible_bridges([component], [bridge]) :: [bridge]
  def possible_bridges(components, [current_bridge | _] = bridges \\ [[]]) do
    port = free_port(current_bridge)
    unused = unused(components, current_bridge)
    matching = matching(unused, port)

    Enum.reduce(matching, bridges, fn m, b ->
      possible_bridges(components, [[m | current_bridge] | b])
    end)
  end

  defp matching(components, port) do
    Enum.filter(components, fn
      {{^port, _free}, _i} -> true
      {{_free, ^port}, _i} -> true
      _ -> false
    end)
  end

  defp unused(components, current_bridge) do
    components -- current_bridge
  end

  defp free_port([]), do: 0
  defp free_port([{{0, free}, _}]), do: free
  defp free_port([{{used, free}, _}, {{used, _}, _} | _]), do: free
  defp free_port([{{used, free}, _}, {{_, used}, _} | _]), do: free
  defp free_port([{{free, used}, _}, {{used, _}, _} | _]), do: free
  defp free_port([{{free, used}, _}, {{_, used}, _} | _]), do: free

  @doc """
  Return the strength of a bridge

  ## Examples

      iex> bridge_strength([{{1,2}, 0}, {{3,4}, 1}])
      10
  """
  @spec bridge_strength(bridge) :: non_neg_integer
  def bridge_strength(bridge) do
    bridge
    |> Enum.map(fn {{port1, port2}, _} -> port1 + port2 end)
    |> Enum.sum()
  end

  @doc false
  @spec components(String.t()) :: [component]
  def components(input) do
    Regex.scan(~r/(\d+)\/(\d+)/, input)
    |> Enum.map(fn [_, port1, port2] ->
         [port1, port2]
         |> Enum.map(&String.to_integer/1)
         |> Enum.sort()
         |> List.to_tuple()
       end)
    |> Enum.sort()
    |> Enum.with_index()
  end
end
