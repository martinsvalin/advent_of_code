defmodule ReportRepair do
  def find_two_with_sum(list, targetSum \\ 2020) do
    case find_two(list, &(&1 + &2 == targetSum)) do
      :error -> {:error, "no two numbers sum to #{targetSum}"}
      ok -> ok
    end
  end

  defp find_two([], _), do: :error

  defp find_two([head | tail], predicate) do
    case Enum.find(tail, &predicate.(head, &1)) do
      nil -> find_two(tail, predicate)
      found -> {:ok, head, found}
    end
  end

  def find_three_with_sum(list, targetSum \\ 2020)

  def find_three_with_sum([], targetSum) do
    {:error, "no three numbers sum to #{targetSum}"}
  end

  def find_three_with_sum([head | tail], targetSum) do
    case find_two_with_sum(tail, targetSum - head) do
      {:ok, a, b} -> {:ok, head, a, b}
      {:error, _reason} -> find_three_with_sum(tail, targetSum)
    end
  end
end
