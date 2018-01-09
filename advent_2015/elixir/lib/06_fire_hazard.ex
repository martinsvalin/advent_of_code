defmodule FireHazard do
  @moduledoc """
  Day 6 - Probably a Fire Hazard

  In a 1000x1000 grid of lights, we toggle lights on and off by regions given as coordinate pairs.
  Each pair represents opposite corners of a rectangle, inclusive; a coordinate pair like
  `0,0 through 2,2` therefore refers to 9 lights in a 3x3 square.

  Instructions are to either `turn on`, `turn off` or `toggle` lights.

  The lights all start turned off.

  In part 2, we realize we've mistranslated the instructions. The lights have brightness controls,
  and we are to set the brightness level:

  - `turn on` means to increase the brightness by 1.
  - `turn off` means to decrease the brightness by 1, to a minimum of zero.
  - `toggle` means to increase the brightness by 2.

  Part 1: After following the instructions, how many lights are lit?
  Part 2: After following the _correct_ instructions, what is the total brightness of the grid?
  """

  def part1(input) do
    input |> light_em_up(&light_region/2) |> Map.values() |> Enum.sum()
  end

  def part2(input) do
    input |> light_em_up(&brightness_control/2) |> Map.values() |> Enum.sum()
  end

  @doc """
  Light 'em up! Adjust the lights in the grid according to your interpretation of the instructions
  """
  def light_em_up(input, instruction_interpretation) do
    input |> parse_instructions() |> Enum.reduce(%{}, instruction_interpretation)
  end

  @doc """
  Turn lights in region on, off or toggle them.
  """
  def light_region({:on, {top_x, top_y}, {bottom_x, bottom_y}}, grid) do
    for x <- top_x..bottom_x, y <- top_y..bottom_y, into: grid, do: {{x,y}, 1}
  end
  def light_region({:off, {top_x, top_y}, {bottom_x, bottom_y}}, grid) do
    for x <- top_x..bottom_x, y <- top_y..bottom_y, into: grid, do: {{x,y}, 0}
  end
  def light_region({:toggle, {top_x, top_y}, {bottom_x, bottom_y}}, grid) do
    for x <- top_x..bottom_x, y <- top_y..bottom_y, into: grid do
      {{x,y}, abs(Map.get(grid, {x,y}, 0) - 1)}
    end
  end

  @doc """
  Control brightness. On => +1, Off => -1, Toggle => +2
  """
  def brightness_control({:on, {top_x, top_y}, {bottom_x, bottom_y}}, grid) do
    for x <- top_x..bottom_x, y <- top_y..bottom_y, into: grid, do: {{x,y}, Map.get(grid, {x,y}, 0) + 1}
  end
  def brightness_control({:off, {top_x, top_y}, {bottom_x, bottom_y}}, grid) do
    for x <- top_x..bottom_x, y <- top_y..bottom_y, into: grid, do: {{x,y}, max(0, Map.get(grid, {x,y}, 0) - 1)}
  end
  def brightness_control({:toggle, {top_x, top_y}, {bottom_x, bottom_y}}, grid) do
    for x <- top_x..bottom_x, y <- top_y..bottom_y, into: grid do
      {{x,y}, Map.get(grid, {x,y}, 0) + 2}
    end
  end

  defp parse_instructions(input) do
    ~r/(turn off|turn on|toggle) (\d+,\d+) through (\d+,\d+)/
    |> Regex.scan(input)
    |> Enum.map(fn [_full, instruction, top, bottom] ->
         {on_off_or_toggle(instruction), to_coord(top), to_coord(bottom)}
       end)
  end

  defp on_off_or_toggle("turn on"), do: :on
  defp on_off_or_toggle("turn off"), do: :off
  defp on_off_or_toggle("toggle"), do: :toggle

  defp to_coord(string) do
    String.split(string, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
  end
end