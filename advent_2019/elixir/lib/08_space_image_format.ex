defmodule SpaceImageFormat do
  @moduledoc """
  # Day 8: Space Image Format

  Images are a series of digits that represent the color of a single pixel.
  The image width and height are known, and the digits fill in the image
  left-to-right, top-to-bottom in multiple layers.

  For instance, image data 123456789012, for a 3x2 image represents the layers:

      Layer 1: 123
               456
      Layer 2: 789
               012
  """

  @doc """
  Part 1: In the layer with the fewest zeros, what does numbers of 1s and 2s multiply to?
  """
  def part1(input, width \\ 25, height \\ 6) do
    {_, ones, twos} =
      input
      |> layers(width, height)
      |> Enum.map(&count_012/1)
      |> Enum.min_by(fn {zeroes, _, _} -> zeroes end)

    ones * twos
  end

  @doc """
  Part 2: Render the image. What does it read?

  Layers are front-to-back. The colors are 0 = black, 1 = white, 2 = transparent.
  """
  def part2(input, width \\ 25, height \\ 6) do
    input
    |> layers(width, height)
    |> List.zip()
    |> Enum.map(&flatten/1)
    |> Enum.chunk_every(width)
  end

  def layers(input, w, h) do
    input |> to_charlist() |> Enum.chunk_every(w * h)
  end

  def flatten(tuple) when is_tuple(tuple), do: tuple |> Tuple.to_list() |> flatten
  def flatten([?0 | _]), do: ?.
  def flatten([?1 | _]), do: ?#
  def flatten([?2 | t]), do: flatten(t)

  def count_012(list, acc \\ {0, 0, 0})
  def count_012([], acc), do: acc
  def count_012([?0 | rest], {zeroes, ones, twos}), do: count_012(rest, {zeroes + 1, ones, twos})
  def count_012([?1 | rest], {zeroes, ones, twos}), do: count_012(rest, {zeroes, ones + 1, twos})
  def count_012([?2 | rest], {zeroes, ones, twos}), do: count_012(rest, {zeroes, ones, twos + 1})
  def count_012([_ | rest], acc), do: count_012(rest, acc)
end
