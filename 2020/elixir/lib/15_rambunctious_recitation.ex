defmodule RambunctiousRecitation do
  def speak(string) when is_binary(string) do
    string
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> speak()
  end

  def speak(starting_numbers) when is_list(starting_numbers) do
    Stream.unfold(Enum.with_index(starting_numbers), &unfolder/1)
  end

  def unfolder({[], {last, i}, seen}) do
    number =
      case Map.get(seen, last) do
        nil -> 0
        n -> i - n
      end

    {{number, i + 1}, {[], {number, i + 1}, Map.put(seen, last, i)}}
  end

  def unfolder({[head | tail], {last, i}, seen}) do
    {head, {tail, head, Map.put(seen, last, i)}}
  end

  def unfolder([head | tail]) do
    {head, {tail, head, %{}}}
  end
end
