defmodule Advent.BotTest do
  use ExUnit.Case
  alias Advent.Bot

  @state %{current: nil, compared: [], instructions: []}
  @instruction %{low: "bot 1", high: "bot 2"}

  def bot(state \\ %{}) do
    {:ok, pid} = GenServer.start_link(Bot, Map.merge(@state, state))
    pid
  end

  describe "pid/1" do
    test "it returns a pid" do
      assert is_pid(Bot.pid(:some_name))
    end

    test "it starts and registers a process with the given name" do
      Bot.pid(:some_name)
      assert :some_name in Process.registered
    end

    test "it returns the pid of an existing process if the same name is given" do
      pid = Bot.pid(:some_name)
      assert pid == Bot.pid(:some_name)
    end

    test "it accepts string names" do
      pid = Bot.pid(:some_name)
      assert pid == Bot.pid("some_name")
    end
  end

  describe "current/1" do
    test "returns a bots current number" do
      {:ok, bot} = GenServer.start_link(Bot, %{current: 1})
      assert Bot.current(bot) == 1
    end

    test "accepts string names" do
      {:ok, _} = GenServer.start_link(Bot, %{current: 1}, name: :some_name)
      assert Bot.current("some_name") == 1
    end
  end

  describe "compared?/2" do
    test "checks if a bot has compared a pair of numbers" do
      {:ok, bot} = GenServer.start_link(Bot, %{compared: [{1, 2}]})
      assert Bot.compared?(bot, {1, 2})
    end

    test "does not care about order" do
      {:ok, bot} = GenServer.start_link(Bot, %{compared: [{1, 2}]})
      assert Bot.compared?(bot, {2, 1})
    end

    test "accepts string names" do
      {:ok, _} = GenServer.start_link(Bot, %{compared: [{1, 2}]}, name: :some_name)
      assert Bot.compared?("some_name", {1,2})
    end
  end

  describe "give/2" do
    test "it holds on to the first value" do
      bot = bot()
      Bot.give(bot, 1)
      assert Bot.current(bot) == 1
    end

    test "it holds onto the second value if it has no instructions" do
      bot = bot(%{current: 1})
      Bot.give(bot, 2)
      assert Bot.current(bot) == {2,1}
    end

    test "it performs an instruction if it has one and is given a second value" do
      bot = bot(%{instructions: [@instruction], current: 1})
      Bot.give(bot, 2)
      assert Bot.current(@instruction.low) == 1
      assert Bot.current(@instruction.high) == 2
      assert Bot.current(bot) == nil
    end

    test "it accepts string names" do
      {:ok, bot} = GenServer.start_link(Bot, @state, name: :some_name)
      Bot.give("some_name", 1)
      assert Bot.current(bot) == 1
    end

    test "performing instructions on a second value implies that is compares the values" do
      bot = bot(%{instructions: [@instruction], current: 1})
      Bot.give(bot, 2)
      assert Bot.compared?(bot, {1,2})
    end
  end

  describe "instruct/2" do
    test "it stores the instruction for later" do
      bot = bot()

      Bot.instruct(bot, @instruction)
      Bot.give(bot, 1)
      Bot.give(bot, 2)

      assert Bot.current(@instruction.low) == 1
      assert Bot.current(@instruction.high) == 2
      assert Bot.current(bot) == nil
    end

    test "instructions are held in order, so that they are performed oldest first" do
      new_instruction = %{low: "bot 123", high: "bot 456"}
      bot = bot(%{instructions: [@instruction]})

      Bot.instruct(bot, new_instruction)
      Bot.give(bot, 1)
      Bot.give(bot, 2)

      refute :"bot 123" in Process.registered
      refute :"bot 456" in Process.registered
      assert Bot.current(@instruction.low) == 1
      assert Bot.current(@instruction.high) == 2
      assert Bot.current(bot) == nil
    end

    test "a new instruction is immediately performed if the bot is already holding two values" do
      bot = bot(%{current: {1,2}})
      Bot.instruct(bot, @instruction)

      assert Bot.current(@instruction.low) == 1
      assert Bot.current(@instruction.high) == 2
      assert Bot.current(bot) == nil
    end
  end
end
