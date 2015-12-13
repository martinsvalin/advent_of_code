defmodule Presents do
  def wrapping do
    presents
    |> Enum.map(&wrapping/1)
    |> Enum.sum
  end

  defp presents do
    input
    |> String.split
    |> Enum.map(&dimensions/1)
  end

  @external_resource "../input.txt"

  defp input do
    {:ok, content} = File.read(@external_resource)
    content
  end

  defp dimensions(present) do
    present
    |> String.split("x")
    |> Enum.map(&String.to_integer/1)
  end

  defp wrapping(present) do
    present
    |> sides
    |> Enum.sum
  end

  defp sides([w,h,l]) do
    [w*h, h*w, w*l, l*w, l*h, h*l]
  end
end

IO.puts "We need #{Presents.wrapping} sq feet of wrapping."
