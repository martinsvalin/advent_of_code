defmodule SantaFloor do
  @external_resource "#{__DIR__}/../input.txt"

  def final_floor, do: hd floors

  def basement_reached do
    floors
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.find_value(fn {floor, index} -> floor == -1 && index end)
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
