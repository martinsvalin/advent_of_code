defmodule Advent.BalanceBotsTest do
  use ExUnit.Case
  alias Advent.BalanceBots, as: BB
  alias Advent.Bot

  describe "run/1" do
    test "accepts a list of instructions" do
      assert :ok = BB.run(["value 2 goes to bot 1", "bot 1 gives low to bot 2 and high to output 1"])
    end

    test "accepts instructions as string of lines" do
      assert :ok = BB.run("value 2 goes to bot 1\nbot 1 gives low to bot 2 and high to output 1")
    end

    test "trims empty lines" do
      assert :ok = BB.run("\n\n\n")
    end
  end

  describe "perform/1" do
    test "performs instruction to give value to a bot" do
      BB.run("value 0 goes to bot 5")
      assert Bot.current("bot 5") == 0
    end

    test "performs instruction to give high and low values to other bots" do
      BB.run(["value 11 goes to bot 10", "value 12 goes to bot 10", "bot 10 gives low to bot 11 and high to bot 12"])
      assert Bot.current("bot 10") == nil
      assert Bot.current("bot 11") == 11
      assert Bot.current("bot 12") == 12
    end

    test "raises a helpful argument error on unknown instructions" do
      assert_raise(ArgumentError, "Unrecognized instruction: invalid instruction", fn ->
        BB.run("invalid instruction")
      end)
    end

    test "raises a helpful argument error on malformed instructions" do
      assert_raise(ArgumentError, "Unrecognized instruction: value 14 goes to bot a", fn ->
        BB.run("value 14 goes to bot a")
      end)
    end
  end

  describe "who_compared/2" do
    test "gives names of bot processes that have compared two numbers" do
      GenServer.start_link(Bot, %{compared: [{1,2}]}, name: :"bot 1")
      assert BB.who_compared(1, 2) == [:"bot 1"]
    end
  end
end
