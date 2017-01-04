defmodule Advent.Bot do
  use GenServer
  @initial_state %{current: nil, compared: [], instructions: []}

  @doc """
  Get the pid from a bot name, optionally starting the bot
  """
  @spec pid(atom | String.t) :: pid
  def pid(name) when is_binary(name) do
    String.to_atom(name) |> pid
  end
  def pid(name) do
    case GenServer.start_link(__MODULE__, @initial_state, name: name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  @doc """
  See what value the bot is currently holding
  """
  @spec current(String.t | atom | pid) :: integer | nil
  def current(bot) when is_binary(bot), do: current(pid(bot))
  def current(bot), do: GenServer.call(bot, :current)

  @doc """
  Check is the bot has compared a pair of numbers
  """
  @spec compared?(String.t | atom | pid, {integer, integer}) :: boolean
  def compared?(bot, pair) when is_binary(bot), do: compared?(pid(bot), pair)
  def compared?(bot, pair), do: GenServer.call(bot, {:did_you_compare, pair})

  @doc """
  Give a value to a bot.

  This may trigger instructions to pass on values to other bots.
  """
  @spec give(String.t | atom | pid, integer) :: :ok
  def give(bot, value) when is_binary(bot), do: give(pid(bot), value)
  def give(bot, value), do: GenServer.call(bot, {:give, value})

  @doc """
  Pass an instruction to the bot that should carry it out

  Instructions are stored and performed when the bot is holding two chips. If it
  is already holding two chips when receiving the instruction, it is immediately
  carried out.
  """
  @spec instruct(String.t | atom | pid, %{high: pid, low: pid}) :: :ok
  def instruct(bot, instruction) when is_binary(bot), do: instruct(pid(bot), instruction)
  def instruct(bot, instruction), do: GenServer.call(bot, {:instruction, instruction})

  ## Server callbacks

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call(:current, _from, %{current: current} = state), do: {:reply, current, state}

  def handle_call({:did_you_compare, {a, b}}, _from, %{compared: compared} = state) do
    {:reply, {min(a,b), max(a,b)} in compared, state}
  end

  def handle_call({:give, value}, _from, %{current: nil} = state) do
    # we're not holding anything, so just keep it.
    {:reply, :ok, %{state | current: value}}
  end
  def handle_call({:give, value}, _from, %{current: current, instructions: []} = state) do
    # corner case, when we don't have any instructions to carry out, even though we now hold two values
    {:reply, :ok, %{state | current: {value, current} }}
  end
  def handle_call({:give, value}, _from, %{ current: current, instructions: [instruction | tail], compared: compared }) do
    # we have two chips and instructions to carry out.
    pair = compare_and_give({value, current}, instruction)
    {:reply, :ok, %{current: nil, instructions: tail, compared: [pair | compared] }}
  end

  def handle_call({:instruction, new_instruction}, _form, %{current: {a, b}, compared: compared} = state) do
    # corner case, we're already holding two values, but had no instruction for them until now.
    pair = compare_and_give({a, b}, new_instruction)
    {:reply, :ok, %{state | current: nil, compared: [pair | compared] }}
  end
  def handle_call({:instruction, new_instruction}, _from, %{instructions: instructions} = state) do
    # normally, keep ordered instructions around for when we have two chips to compare
    {:reply, :ok, %{state | instructions: instructions ++ [new_instruction]}}
  end

  defp compare_and_give({chip_a, chip_b}, %{low: low_receiver, high: high_receiver}) do
    {low, high} = {min(chip_a, chip_b), max(chip_a, chip_b)}
    :ok = give(low_receiver, low)
    :ok = give(high_receiver, high)
    {low, high}
  end
end
