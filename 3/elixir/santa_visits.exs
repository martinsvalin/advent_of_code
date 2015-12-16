defmodule SantaVisits do
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
  def part1(input) do
    input
    |> String.codepoints
    |> SantaVisits.visited
    |> Enum.count
  end

  def part2(_input) do
  end

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
