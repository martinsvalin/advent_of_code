defmodule EncodingError do
  def find_invalid_number(numbers, window_size \\ 25)

  def find_invalid_number(numbers, window_size) when length(numbers) <= window_size do
    :all_sums_found
  end

  def find_invalid_number(numbers, window_size) do
    {previous_window, [head | _]} = Enum.split(numbers, window_size)

    case find_addends(previous_window, head) do
      {_a, _b} -> find_invalid_number(tl(numbers), window_size)
      :not_found -> head
    end
  end

  def find_encryption_weakness(numbers, window_size \\ 25) do
    case find_invalid_number(numbers, window_size) do
      n when is_integer(n) -> find_range_with_sum(numbers, n)
      _ -> :no_invalid_number_found
    end
  end

  defp find_addends(left \\ [], right, sum)
  defp find_addends(_left, [], _sum), do: :not_found

  defp find_addends(left, [current | right], sum) do
    if (sum - current) in (left ++ right) do
      {current, sum - current}
    else
      find_addends([current | left], right, sum)
    end
  end

  defp find_range_with_sum([], _), do: :dammit

  defp find_range_with_sum(numbers, invalid_number) do
    case try_range(numbers, invalid_number, 2) do
      range when is_list(range) -> Enum.min_max(range)
      :no_dice -> find_range_with_sum(tl(numbers), invalid_number)
    end
  end

  def try_range(numbers, invalid_number, range_size) do
    range = Enum.take(numbers, range_size)

    case Enum.sum(range) do
      ^invalid_number -> range
      n when n > invalid_number -> :no_dice
      n when n < invalid_number -> try_range(numbers, invalid_number, range_size + 1)
    end
  end
end
