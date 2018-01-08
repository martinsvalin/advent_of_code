defmodule SantaFloor do
  def final_floor(input), do: input |> floors() |> hd()

  def basement_reached(input) do
    input
    |> floors()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.find_value(fn {floor, index} -> floor == -1 && index end)
  end

  defp floors(input) do
    input
    |> String.codepoints()
    |> Enum.reduce([0], fn codepoint, [current | _tail] = floors ->
         case codepoint do
           "(" -> [current + 1 | floors]
           ")" -> [current - 1 | floors]
           _ -> floors
         end
       end)
  end
end
