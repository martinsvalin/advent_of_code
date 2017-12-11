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

  @distance_growth %{
    "n"  => %{"n" =>  1, "nw" =>  1, "sw" =>  0, "s" => -1, "se" =>  0, "ne" =>  1, },
    "nw" => %{"n" =>  1, "nw" =>  1, "sw" =>  1, "s" =>  0, "se" => -1, "ne" =>  0, },
    "sw" => %{"n" =>  0, "nw" =>  1, "sw" =>  1, "s" =>  1, "se" =>  0, "ne" => -1, },
    "s"  => %{"n" => -1, "nw" =>  0, "sw" =>  1, "s" =>  1, "se" =>  1, "ne" =>  0, },
    "se" => %{"n" =>  0, "nw" => -1, "sw" =>  0, "s" =>  1, "se" =>  1, "ne" =>  1, },
    "ne" => %{"n" =>  1, "nw" =>  0, "sw" => -1, "s" =>  0, "se" =>  1, "ne" =>  1, }
  }

  @substitute %{
    "n"  => %{"sw" => "nw", "se" => "ne"},
    "nw" => %{"s"  => "sw", "ne" => "n"},
    "sw" => %{"n"  => "nw", "se" => "s"},
    "s"  => %{"nw" => "sw", "ne" => "se"},
    "se" => %{"n"  => "ne", "sw" => "s"},
    "ne" => %{"nw" => "n",  "s"  => "se"}
  }

  @doc false
  def traverse_hex_grid(to, []), do: [to]
  def traverse_hex_grid(to, [prev|t]) do
    IO.inspect(to: to, prev: prev)
    IO.inspect(distance_growth: @distance_growth[prev][to])
    case @distance_growth[prev][to] do
      -1 -> t
       1 -> [to, prev | t]
       0 -> [@substitute[prev][to] | t]
    end
  end

  defp to_instructions(string) do
    string
    |> String.trim_trailing()
    |> String.split(",")
  end
end