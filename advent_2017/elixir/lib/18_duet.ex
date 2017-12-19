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

  def start(id, ops) do
    GenServer.start(__MODULE__, {id, ops})
  end

  def run(pid, other) do
    GenServer.cast(pid, {:run, other})
  end

  def run({_left, []} = ops, reg, id, other, sent) do
    # IO.puts("#{id} --- Ran out of instructions. Stopping")
    {:done, {ops, reg, id, other, sent}}
  end

  def run({left, [{cmd, x, y} = op | right]}, reg, id, other, sent)
      when cmd in [:set, :add, :mul, :mod] do
    # IO.puts("#{id} --- op #{inspect(op)} on register #{inspect(reg)}")
    run({[op | left], right}, apply(Duet, cmd, [reg, x, y]), id, other, sent)
  end

  def run({left, [{:jgz, x, y} = op | right] = op_right}, reg, id, other, sent) do
    case Duet.val(reg, x) do
      x when x <= 0 ->
        # IO.puts("#{id} --- no jump")
        run({[op | left], right}, reg, id, other, sent)

      _ ->
        val_y = Duet.val(reg, y)
        # IO.puts("#{id} --- jumping by #{val_y}")

        case Duet.jump(left, op_right, val_y) do
          :error ->
            # IO.puts("#{id} --- jump error, stopping.")
            GenServer.stop(self())

          ops ->
            run(ops, reg, id, other, sent)
        end
    end
  end

  def run({left, [{:snd, x} = op | right]}, reg, id, other, sent) do
    # IO.puts("#{id} (pid #{inspect(self())}) is sending #{x} to other (pid #{inspect(other)})")
    GenServer.cast(other, {:message, x})
    run({[op | left], right}, reg, id, other, sent + 1)
  end

  def run({_, [{:rcv, x} | _]} = ops, reg, id, other, sent) do
    # IO.puts("#{id} is waiting to receive in #{x}")
    {ops, reg, id, other, sent}
  end

  @impl GenServer
  def init({id, ops}) do
    {:ok, {{[], ops}, %{"p" => id}, id, nil, 0}}
  end

  @impl GenServer
  def handle_cast({:run, other}, {ops, reg, id, _, sent}) do
    # IO.puts("#{id} --- Running")
    {:noreply, run(ops, reg, id, other, sent), 2_000}
  end

  def handle_cast({:message, val}, {{left, [{:rcv, key} = op | right]}, reg, id, other, sent}) do
    # IO.puts("#{id} --- Receiving #{val} to put into #{key}")
    case run({[op | left], right}, Duet.set(reg, key, val), id, other, sent) do
      {:done, state} -> {:stop, :normal, state}
      state -> {:noreply, state, 2_000}
    end
  end

  @impl GenServer
  def handle_info(:timeout, {_ops, _reg, id, _other, sent} = state) do
    # IO.puts "#{id} --- Timed out. This program sent #{sent} messages"
    {:stop, :normal, state}
  end

  @impl GenServer
  def terminate(:normal, {_ops, _reg, id, _other, sent}) do
    IO.puts("#{id} --- Terminated. This program sent #{sent} messages")
  end
end
