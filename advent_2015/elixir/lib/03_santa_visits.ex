defmodule SantaVisits do
  @moduledoc """
  Work out which houses Santa delivers presents to on a grid where there's a
  house at every cell, following instructions to go up|down|left|right.
  Instructions are given as a list of ^ v < > strings.
  """

  @doc """
  Given some input, answer the question in part 1, where we give all
  instructions to Santa, and count the houses he visited at least once.
  """
  def part1(input) do
    input
    |> to_charlist()
    |> visited()
    |> Enum.uniq
    |> Enum.count
  end

  @doc """
  Given some input, answer the question in part 2, where we alternate the
  instructions between Santa and Robo-Santa, and count the houses visited by
  either at least once.
  """
  def part2(input) do
    instructions = to_charlist(input)
    santas = instructions |> Enum.take_every(2)
    robos = instructions |> Enum.drop(1) |> Enum.take_every(2)

    (visited(santas) ++ visited(robos))
    |> Enum.uniq
    |> Enum.count
  end

  @doc """
  Returns a list of unique coordinates (2-tuples) that Santa visited.

  Takes instructions to go up|down|left|right (in the form of ^ v < > codepoints).
  """
  def visited(instructions) do
    Enum.reduce(instructions, [{0,0}], &follow_instructions/2)
  end
  
  defp follow_instructions(?^, [{x, y}|_] = visited), do: [{x, y + 1} | visited]
  defp follow_instructions(?v, [{x, y}|_] = visited), do: [{x, y - 1} | visited]
  defp follow_instructions(?<, [{x, y}|_] = visited), do: [{x + 1, y} | visited]
  defp follow_instructions(?>, [{x, y}|_] = visited), do: [{x - 1, y} | visited]
  defp follow_instructions(_, visited), do: visited
end
