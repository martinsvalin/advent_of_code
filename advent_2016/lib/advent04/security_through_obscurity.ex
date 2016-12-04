defmodule Advent.SecurityThroughObscurity do
  @moduledoc """
  # Advent of Code, Day 4: Security Through Obscurity
  """

  @typep room :: %{name: String.t, sector_id: integer, checksum: String.t}

  @doc """
  Parse input to rooms

  ## Examples

      iex> rooms("aaaaa-bbb-z-y-x-123[abxyz]")
      [%{name: "aaaaa-bbb-z-y-x", sector_id: 123, checksum: "abxyz"}]
  """
  @spec rooms(String.t) :: [room]
  def rooms(input) do
    input
    |> String.split
    |> Enum.map(&room/1)
  end

  @doc """
  Parse a single room

  ## Examples

      iex> room("aaaaa-bbb-z-y-x-123[abxyz]")
      %{name: "aaaaa-bbb-z-y-x", sector_id: 123, checksum: "abxyz"}
  """
  @spec room(String.t) :: room
  def room(string) do
    parsed = Regex.named_captures(~r/(?<name>.*)-(?<sector_id>\d+)\[(?<checksum>\w+)\]/, string)
    %{
      name: parsed["name"],
      sector_id: String.to_integer(parsed["sector_id"]),
      checksum: parsed["checksum"]
    }
  end

  @doc """
  Check that the checksum checks out for a room

  ## Examples

      iex> valid_room?(%{name: "aaaaa-bbb-z-y-x", sector_id: 123, checksum: "abxyz"})
      true
  """
  @spec valid_room?(room) :: boolean
  def valid_room?(%{name: name, checksum: checksum}) do
    checksum(name) == checksum
  end

  @doc """
  Calculate checksum for a room name

  ## Examples

      iex> checksum("aaaaa-bbb-z-y-x")
      "abxyz"
  """
  @spec checksum(String.t) :: String.t
  def checksum(name) do
    name
    |> letter_frequency
    |> Enum.sort_by(fn {letter, freq} -> -freq end)
    |> Keyword.keys
    |> Enum.take(5)
    |> Enum.join
  end

  @doc """
  Letter frequency of a room name. Ignores dashes

  ## Examples

      iex> letter_frequency("aaaaa-bbb-z-y-x")
      %{"a" => 5, "b" => 3, "z" => 1, "y" => 1, "x" => 1}
  """
  @spec letter_frequency(String.t) :: map
  def letter_frequency(name) do
    name
    |> String.replace("-", "")
    |> String.graphemes
    |> Enum.reduce(%{}, fn letter, acc ->
      Map.update(acc, letter, 1, & &1 + 1)
    end)
  end
end
