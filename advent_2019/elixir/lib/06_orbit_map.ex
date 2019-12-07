defmodule OrbitalMap do
  @moduledoc """
  # Day 6: Universal Orbit Map

  https://adventofcode.com/2019/day/6

  Except for the universal Center of Mass (COM), every object in space is in
  orbit around exactly one other object. This relation is represented in the
  input as A)B, where B directly orbits around A. If C orbits B, then it
  indirectly orbits A.

  ## Part 1: What is the checksum of all orbits?

  The checksum is the sum of all object's number of direct and indirect orbits.
  In COM)A,A)B, the checksum is 3.

  ## Part 2: How many orbital transfers are there between you and santa?

  YOU and SAN are objects in the map, each orbiting objects. How many orbital
  transfers are needed to travel from the object YOU are orbiting to the object
  SAN is orbiting?
  """

  def part1(lines \\ Util.lines(6)), do: lines |> build_graph() |> checksum()
  def part2(lines \\ Util.lines(6)), do: lines |> build_graph() |> transfers("YOU", "SAN")

  @spec build_graph([String.t()]) :: :digraph.graph()
  def build_graph(lines) do
    lines
    |> Enum.map(&String.split(&1, ")"))
    |> Enum.reduce(:digraph.new([:acyclic]), fn [v1, v2], graph ->
      :digraph.add_vertex(graph, v1)
      :digraph.add_vertex(graph, v2)
      :digraph.add_edge(graph, v1, v2)
      graph
    end)
  end

  @doc "Checksum for an orbital map"
  @spec checksum(:digraph.graph()) :: integer()
  def checksum(graph) do
    sum_orbits(:digraph.vertices(graph), root(graph), graph, 0)
  end

  @doc "Number of transfers needed for subject to go to the same object as destination"
  @spec transfers(:digraph.graph(), String.t(), String.t()) :: integer()
  def transfers(graph, subject, destination) do
    root = root(graph)
    path1 = :digraph.get_path(graph, root, subject)
    path2 = :digraph.get_path(graph, root, destination)

    length((path1 -- [subject]) -- path2) + length((path2 -- [destination]) -- path1)
  end

  def sum_orbits([], _, _, sum), do: sum

  def sum_orbits([v | vertices], root, graph, sum) do
    sum_orbits(vertices, root, graph, sum + path_length(graph, root, v))
  end

  def path_length(graph, v1, v2) do
    case :digraph.get_path(graph, v1, v2) do
      false -> 0
      [_ | tail] -> length(tail)
    end
  end

  def root(graph) do
    {:yes, root} = :digraph_utils.arborescence_root(graph)
    root
  end
end
