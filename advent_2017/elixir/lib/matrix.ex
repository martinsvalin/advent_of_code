defmodule Matrix do
  @moduledoc """
  Helpful Matrix functions
  """

  @doc """
  Returns all eight variations of a matrix by rotations and flips

  ## Examples

      iex> Matrix.variations([[1,2], [3,4]])
      [
        [[1, 2], [3, 4]],
        [[2, 4], [1, 3]],
        [[4, 3], [2, 1]],
        [[3, 1], [4, 2]],
        [[3, 4], [1, 2]],
        [[4, 2], [3, 1]],
        [[2, 1], [4, 3]],
        [[1, 3], [2, 4]]
      ]
  """
  def variations(pattern) do
    rotations(pattern) ++ rotations(Enum.reverse(pattern))
  end

  defp rotations(pattern) do
    r1 = rotate(pattern)
    r2 = rotate(r1)
    r3 = rotate(r2)
    [pattern, r1, r2, r3]
  end

  @doc """
  Rotate a matrix to the left

  ## Examples

      iex> Matrix.rotate([[1,2], [3,4]])
      [[2,4], [1,3]]
  """
  def rotate(pattern), do: rotate(pattern, [], [], [])

  defp rotate([[] | _], [], [], acc), do: acc

  defp rotate([], remaining, current, acc) do
    rotate(Enum.reverse(remaining), [], [], [Enum.reverse(current) | acc])
  end

  defp rotate([[v | vs] | rows], remaining, current, acc) do
    rotate(rows, [vs | remaining], [v | current], acc)
  end
end
