defmodule DigitalPlumber do
  @moduledoc """
  Day 12 - Digital Plumber

  We see a collection of programs communicating via bidirectional pipes.
  Each program is connected to one or more other programs, but not all
  programs are reachable.

  1. How big is the group of programs that can reach the one with ID 0?
  """

  @doc """
  The number of programs that can reach the program with the given ID
  """
  @spec group_size(String.t(), non_neg_integer()) :: pos_integer()
  def group_size(programs, id) do
    graph = :digraph.new()

    programs
    |> build_graph(graph)
    |> group(id)
    |> length()
  end

  @doc """
  Return the unconnected groups in a graph
  """
  def groups(programs) do
    vertices = programs |> to_vertices()
    graph = :digraph.new()

    build_graph(vertices, graph)

    groups(Enum.map(vertices, &elem(&1, 0)), graph, [])
  end

  defp groups([], _, groups), do: groups

  defp groups([id | tail], graph, groups) do
    group = group(graph, id)
    groups(tail -- group, graph, [group | groups])
  end

  defp group(graph, id), do: :digraph_utils.reachable([id], graph)

  defp build_graph(programs, graph) when is_binary(programs) do
    programs |> to_vertices() |> build_graph(graph)
  end

  defp build_graph(programs, graph) when is_list(programs) do
    programs |> Enum.each(&add_to_graph(&1, graph))
    graph
  end

  defp add_to_graph({vertex, connected}, graph) do
    Enum.each([vertex | connected], &:digraph.add_vertex(graph, &1))
    Enum.each(connected, &:digraph.add_edge(graph, vertex, &1))
    Enum.each(connected, &:digraph.add_edge(graph, &1, vertex))
  end

  @vertex_regex ~r/(\d+) <-> (\d+(, \d+)*)/

  defp to_vertices(input) do
    Regex.scan(@vertex_regex, input)
    |> Enum.map(fn
         [_, id, connected] -> to_vertex(id, connected)
         [_, id, connected, _] -> to_vertex(id, connected)
       end)
  end

  defp to_vertex(id, connected) do
    {String.to_integer(id), String.split(connected, ", ") |> Enum.map(&String.to_integer/1)}
  end
end
