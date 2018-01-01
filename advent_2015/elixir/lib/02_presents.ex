defmodule Presents do
  def total_wrapping(input) do
    input
    |> presents()
    |> Enum.map(&wrapping/1)
    |> Enum.sum
  end

  def total_ribbon(input) do
    input
    |> presents()
    |> Enum.map(&ribbon/1)
    |> Enum.sum
  end

  defp presents(input) do
    input
    |> String.split()
    |> Enum.map(&dimensions/1)
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

  defp ribbon(present) do
    present
    |> perimeters
    |> Enum.min
  end

  defp perimeters([w,h,l]) do
    [2*w + 2*h, 2*w + 2*l, 2*h + 2*l]
  end
end
