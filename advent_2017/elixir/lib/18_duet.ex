defmodule Duet do
  @moduledoc """
  Dec 18 - Duet

  A set of operations manipulate registers that hold integer values.
  The operations are:

      snd X    plays a sound with a frequency equal to the value of X.
      set X Y  sets register X to the value of Y.
      add X Y  increases register X by the value of Y.
      mul X Y  multiplies register X by the value of Y.
      mod X Y  modulo register X by the value of Y.
      rcv X    recovers the frequency of the last sound played, if X != 0
      jgz X Y  jumps ops with an offset of the value of Y, if X > zero.

  A jump outside the operation buffer terminates the program.

  1. What is the value of the recovered frequency?
  """

  @doc """
  Recover the last frequency played
  """
  def recover_frequency(input) do
    recover_frequency({[], ops(input)}, %{}, [])
  end

  def recover_frequency({left, [{:snd, x} = op | right]}, register, sounds) do
    recover_frequency({[op | left], right}, register, [val(register, x) | sounds])
  end

  def recover_frequency({left, [{:rcv, x} = op | right]}, register, sounds) do
    case val(register, x) do
      0 -> recover_frequency({[op | left], right}, register, sounds)
      _ -> hd(sounds)
    end
  end

  def recover_frequency({left, [{:jgz, x, y} = op | right] = op_right}, register, sounds) do
    case val(register, x) do
      x when x <= 0 ->
        recover_frequency({[op | left], right}, register, sounds)

      _ ->
        jump(left, op_right, val(register, y))
        |> recover_frequency(register, sounds)
    end
  end

  def recover_frequency({left, [{cmd, x, y} = op | right]}, register, sounds) do
    recover_frequency({[op | left], right}, apply(__MODULE__, cmd, [register, x, y]), sounds)
  end

  def set(reg, x, y) do
    Map.put(reg, x, val(reg, y))
  end

  def add(reg, x, y) do
    Map.put(reg, x, val(reg, x) + val(reg, y))
  end

  def mul(reg, x, y) do
    Map.put(reg, x, val(reg, x) * val(reg, y))
  end

  def mod(reg, x, y) do
    remainder = rem(val(reg, x), val(reg, y))
    Map.put(reg, x, remainder)
  end

  def jump(left, right, 0), do: {left, right}

  def jump(left, right, y) when y < 0 do
    {right, left} = jump(right, left, -y)
    {left, right}
  end

  def jump(left, [op | right], y) do
    jump([op | left], right, y - 1)
  end

  def jump(_, _, _), do: :error

  def val(_, x) when is_integer(x), do: x
  def val(register, x) do
    case Integer.parse(x) do
      {int, ""} -> int
      _ -> Map.get(register, x, 0)
    end
  end

  def ops(input) do
    Regex.scan(~r/[\w-]+/, input)
    |> parse([])
  end

  def parse([], ops), do: Enum.reverse(ops)
  def parse([["snd"], [x] | rest], ops), do: parse(rest, [{:snd, x} | ops])
  def parse([["set"], [x], [y] | rest], ops), do: parse(rest, [{:set, x, y} | ops])
  def parse([["add"], [x], [y] | rest], ops), do: parse(rest, [{:add, x, y} | ops])
  def parse([["mul"], [x], [y] | rest], ops), do: parse(rest, [{:mul, x, y} | ops])
  def parse([["mod"], [x], [y] | rest], ops), do: parse(rest, [{:mod, x, y} | ops])
  def parse([["rcv"], [x] | rest], ops), do: parse(rest, [{:rcv, x} | ops])
  def parse([["jgz"], [x], [y] | rest], ops), do: parse(rest, [{:jgz, x, y} | ops])
end

defmodule Duet.Server do
  use GenServer

  alias __MODULE__, as: DS

  defstruct id: nil, other: nil, parent: nil, left: [], right: [], register: %{}, sent_count: 0

  def start(id, ops) do
    GenServer.start(__MODULE__, {id, ops, self()})
  end

  def solve(pid, other: other) do
    GenServer.cast(pid, {:run, other})
  end

  def run(%DS{right: [op | _]} = state) do
    case op do
      {:snd, val} -> snd(state, val)
      {:rcv, key} -> rcv(state, key)
      {:jgz, key, offset} -> jgz(state, key, offset)
      {cmd, x, y} -> cmd(state, cmd, x, y)
    end
  end

  def run(%DS{right: []} = state) do
    {:no_more_ops, state}
  end

  def cmd(state, cmd, x, y) when cmd in [:set, :add, :mul, :mod] do
    state
    |> forward()
    |> Map.put(:register, apply(Duet, cmd, [state.register, x, y]))
    |> run()
  end

  def jgz(state, key, offset) do
    case Duet.val(state.register, key) do
      x when x <= 0 ->
        state |> forward() |> run()

      _ ->
        offset_value = Duet.val(state.register, offset)

        case Duet.jump(state.left, state.right, offset_value) do
          :error ->
            {:jump_error, state}

          {left, right} ->
            run(%DS{state | left: left, right: right})
        end
    end
  end

  def snd(state, val) do
    GenServer.cast(state.other, {:message, Duet.val(state.register, val)})
    state
    |> forward()
    |> Map.update(:sent_count, 1, & &1 + 1)
    |> run()
  end

  def rcv(state, _key) do
    state
  end

  def forward(%DS{left: left, right: [op | right]} = state) do
    %DS{state | left: [op | left], right: right}
  end

  @impl GenServer
  def init({id, ops, parent}) do
    {:ok, %DS{right: ops, register: %{"p" => id}, id: id, parent: parent}}
  end

  @impl GenServer
  def handle_cast({:run, other}, state) do
    state
    |> Map.put(:other, other)
    |> run()
    |> case do
         {:no_more_ops, state} -> {:stop, :normal, {:no_more_ops, state}}
         {:jump_error, state} -> {:stop, :normal, {:jump_error, state}}
         %DS{} = state -> {:noreply, state, 20}
       end
  end

  def handle_cast({:message, val}, %DS{right: [{:rcv, key} | _], register: reg} = state) do
    state
    |> forward()
    |> Map.put(:register, Duet.set(reg, key, val))
    |> run()
    |> case do
         {:no_more_ops, state} -> {:stop, :normal, {:no_more_ops, state}}
         {:jump_error, state} -> {:stop, :normal, {:jump_error, state}}
         %DS{} = state -> {:noreply, state, 20}
       end
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    {:stop, :normal, {:timeout, state}}
  end

  @impl GenServer
  def terminate(:normal, {reason, %DS{id: id, sent_count: sent, parent: parent}}) do
    send(parent, {id, sent, "Program #{id} terminated. Reason: #{reason}. Sent #{sent} messages"})
  end
end
