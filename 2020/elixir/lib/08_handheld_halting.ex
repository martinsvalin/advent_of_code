defmodule HandheldHalting do
  def repair_program(lines) do
    lines
    |> parse()
    |> mutate()
    |> Enum.find_value(fn program ->
      case run(program) do
        {:exit, pointer, acc} -> {:exit, pointer, acc}
        _ -> false
      end
    end)
  end

  def mutate(program) do
    Enum.reduce(Map.keys(program), [program], fn index, programs ->
      case Map.get(program, index) do
        {:nop, n} -> [Map.put(program, index, {:jmp, n}) | programs]
        {:jmp, n} -> [Map.put(program, index, {:nop, n}) | programs]
        {:acc, _} -> programs
      end
    end)
  end

  def detect_infinite_loop(lines) do
    lines |> parse() |> run()
  end

  defp parse(lines) do
    lines
    |> Enum.with_index()
    |> Map.new(fn
      {<<op::3-bytes, " ", number::binary>>, index} ->
        {index, {String.to_existing_atom(op), String.to_integer(number)}}
    end)
  end

  defp run(program), do: run(program, 0, 0, MapSet.new())

  defp run(program, pointer, acc, _) when pointer == map_size(program) do
    {:exit, pointer, acc}
  end

  defp run(program, pointer, acc, seen) do
    if pointer in seen do
      {:loop, pointer, acc}
    else
      case Map.get(program, pointer) do
        {:nop, _} -> run(program, pointer + 1, acc, MapSet.put(seen, pointer))
        {:jmp, n} -> run(program, pointer + n, acc, MapSet.put(seen, pointer))
        {:acc, n} -> run(program, pointer + 1, acc + n, MapSet.put(seen, pointer))
        nil -> {:error, pointer, acc}
      end
    end
  end
end
