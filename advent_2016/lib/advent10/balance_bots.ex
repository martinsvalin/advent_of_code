defmodule Advent.BalanceBots do
  @moduledoc """
  # Advent of Code, Day 10: Balance Bots

  See: http://adventofcode.com/2016/day/10
  """
  alias Advent.Bot

  @doc """
  Carry out the given bot instructions in the system

  This will parse the input and start bot processes as needed. Bots are named,
  registered processes that can be given values to hold, or instructions to
  give chips to other bots.
  """
  def run(instructions) when is_binary(instructions) do
    instructions
    |> String.split("\n", trim: true)
    |> run
  end
  def run([]), do: :ok
  def run([instruction | rest]) do
    perform(instruction)
    run(rest)
  end

  @doc """
  List of bots that compared the two values

  This will ask all registered bot processes if they've compared the two values.
  """
  def who_compared(a, b) do
    Process.registered
    |> Enum.filter(fn name -> match?("bot"<>_, to_string(name)) end)
    |> Enum.filter(&Bot.compared?(&1, {a, b}))
  end

  @doc """
  Perform a single instruction.

  An instruction has to follow one of two specific patterns:

      <value> goes to <bot>
      <bot> gives low to <receiver> and high to <receiver>

  Where <value> is e.g. "value 12", <bot> is e.g. "bot 1" and <receiver> is
  e.g. "bot 2" or "output 2". All other instructions raise `ArgumentError`.
  """
  def perform(instruction) do
    case parse(instruction) do
      nil -> unrecognized(instruction)
      %{"value" => value, "bot" => bot} ->
        :ok = Bot.give(bot, String.to_integer(value))
      %{"giver" => giver, "low_receiver" => low_receiver, "high_receiver" => high_receiver} ->
        Bot.instruct(giver, %{high: high_receiver, low: low_receiver})
    end
  end

  @value_goes_to ~r/value (?<value>\d+) goes to (?<bot>bot \d+)/
  @give_high_and_low ~r/(?<giver>bot \d+) gives low to (?<low_receiver>(output|bot) \d+) and high to (?<high_receiver>(output|bot) \d+)/
  defp parse(instruction) do
    Regex.named_captures(@value_goes_to, instruction) || Regex.named_captures(@give_high_and_low, instruction)
  end

  defp unrecognized(instruction), do: raise ArgumentError, "Unrecognized instruction: #{instruction}"
end
