defmodule SantaVisits do
  @moduledoc """
  Work out which houses Santa delivers presents to on a grid where there's a
  house at every cell, following instructions to go up|down|left|right.
  Instructions are given as a list of ^ v < > strings.
  """

  @doc """
  Takes instructions to go up|down|left|right (in the form of ^ v < > strings).
  Returns a list of unique coordinates (2-tuples) that Santa visited.
  """
  def visited(instructions) do
    instructions
    |> Enum.reduce([{0,0}], &follow_instructions/2)
    |> Enum.uniq
  end

  defp follow_instructions(instruction, [{x, y}|_] = visited) do
    case instruction do
      "^" -> [{x, y + 1} | visited]
      "v" -> [{x, y - 1} | visited]
      "<" -> [{x + 1, y} | visited]
      ">" -> [{x - 1, y} | visited]
      _ -> visited
    end
  end
end

defmodule Answer do
  @doc """
  Given some input, answer the question in part 1, where we give all
  instructions to Santa, and count the houses he visited at least once.
  """
  def part1(input) do
    input
    |> String.codepoints
    |> SantaVisits.visited
    |> Enum.count
  end

  @doc """
  Given some input, answer the question in part 2, where we alternate the
  instructions between Santa and Robo-Santa, and count the houses visited by
  either at least once.
  """
  def part2(input) do
    part1(input)
  end

  @doc """
  Check that our solution is correct by asserting against known answers to given
  input.

  ## Examples
      iex> Answer.check :part1, "^v", 2
      :ok
      iex> Answer.check :part2, "^v", 2
      ** (RuntimeError) Wrong answer. Expected 2, got 3
  """
  def check(:part1, input, expected), do: assert(Answer.part1(input), expected)
  def check(:part2, input, expected), do: assert(Answer.part2(input), expected)

  defp assert(actual, expected) do
    case actual do
      ^expected -> :ok
      _ ->  raise "Wrong answer. Expected #{expected}, got #{actual}"
    end
  end
end

Answer.check :part1, ">", 2
Answer.check :part1, "^>v<", 4
Answer.check :part1, "^v^v^v^v^v", 2

{:ok, input} = File.read("../input.txt")
IO.puts "Santa delivers at least one present to #{Answer.part1(input)} houses."

Answer.check :part2, "^v", 3
Answer.check :part2, "^>v<", 3
Answer.check :part2, "^v^v^v^v^v", 11

IO.puts "Next year, Santa and Robo-Santa deliver to #{Answer.part2(input)} houses."
