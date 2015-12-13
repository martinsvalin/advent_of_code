defmodule SantaFloor do
  @external_resource "../input.txt"

  def final_floor, do: hd floors

  def basement_reached do
    {_, index} = floors
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.find(fn {floor, _index} -> floor == -1 end)
    index
  end

  defp input do
    {:ok, content} = File.read(@external_resource)
    content
  end

  defp floors do
    input
    |> String.codepoints
    |> Enum.reduce([0], fn(codepoint, [current | _tail] = floors) ->
      case codepoint do
        "(" -> [current + 1 | floors]
        ")" -> [current - 1 | floors]
        _   -> floors
      end
    end)
  end
end

IO.puts "Santa is going to floor #{SantaFloor.final_floor}"
IO.puts "Santa reaches the basement after #{SantaFloor.basement_reached} moves"
