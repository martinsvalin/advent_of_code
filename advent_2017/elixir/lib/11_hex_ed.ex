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

  Can be called with either comma-separated numbers in a string, or with
  a list of numbers.

  ## Examples

      iex> HexEd.final_distance("n,nw,s")
      1
      iex> HexEd.final_distance(~w(n nw s))
      1
  """
  @spec final_distance(String.t) :: non_neg_integer()
  @spec final_distance([String.t]) :: non_neg_integer()
  def final_distance(input) do
    input |> distances() |> List.last()
  end

  @doc """
  Calculate the distance to the furthest point we reach following the instructions

  ## Examples

      iex> HexEd.furthest_distance("n,n,s,s")
      2
  """
  @spec furthest_distance(String.t) :: non_neg_integer()
  @spec furthest_distance([String.t]) :: non_neg_integer()
  def furthest_distance(input) do
    input |> distances() |> Enum.max()
  end


  @doc """
  Calculate the distance for each step as we follow the directions

  ## Examples

      iex> HexEd.distances("n,n,s,s")
      [1,2,1,0]
  """
  @spec distances(String.t) :: [non_neg_integer()]
  @spec distances([String.t]) :: [non_neg_integer()]
  def distances(input) when is_binary(input), do: input |> to_instructions() |> distances
  def distances(input) when is_list(input) do
    input
    |> Enum.reduce([], &count_directions/2)
    |> Enum.map(&calculate_distance/1)
    |> Enum.reverse()
  end

  defp count_directions(dir, []), do: [%{dir => 1}]
  defp count_directions(dir, [prev | _] = counts) do
    [Map.update(prev, dir, 1, & &1 + 1) | counts]
  end

  @opposite %{
    "n" => "s",
    "nw" => "se",
    "sw" => "ne",
    "s" => "n",
    "se" => "nw",
    "ne" => "sw"
  }

  def calculate_distance(counts) do
    counts
    |> cancel_out_opposite()
    |> Map.values()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(2)
    |> Enum.sum
  end

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