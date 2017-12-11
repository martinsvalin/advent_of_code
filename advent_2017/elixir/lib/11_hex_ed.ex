defmodule HexEd do
  @moduledoc """
  Dec 10 - Hex Ed

  A little child process is lost on an infinite hex grid. We know the steps,
  which are given as directions (n,nw,sw,s,se,ne).

  Here is a sketch of a hex grid showing the directions:

             \ n  /
           nw +--+ ne
             /    \
           -+      +-
             \    /
           sw +--+ se
             / s  \
"""

  @doc """
  The shortest distance to where the instuctions take us on the hex grid

  ## Examples

      iex> HexEd.distance("n,nw,s")
      1
  """
  @spec distance(String.t) :: non_neg_integer()
  def distance(input) do
    input
    |> to_instructions()
    |> Enum.reduce(%{}, &count_directions/2)
    |> cancel_out_opposite()
    |> Map.values()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(2)
    |> Enum.sum
  end

  def count_directions(dir, counts) do
    Map.update(counts, dir, 1, & &1 + 1)
  end

  @opposite %{
    "n" => "s",
    "nw" => "se",
    "sw" => "ne",
    "s" => "n",
    "se" => "nw",
    "ne" => "sw"
  }

  def cancel_out_opposite(counts) do
    Enum.reduce(counts, %{}, fn
      {dir, count}, cancelled ->
        opp_count = Map.get(counts, @opposite[dir], 0)
        Map.put(cancelled, dir, max(count - opp_count, 0))
    end)
  end

  defp to_instructions(string) do
    string
    |> String.trim_trailing()
    |> String.split(",")
  end
end