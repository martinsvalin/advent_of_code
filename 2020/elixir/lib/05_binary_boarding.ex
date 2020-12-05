defmodule BinaryBoarding do
  def max_seat_id(lines) do
    lines
    |> Enum.map(&seat_from_boarding_pass/1)
    |> Enum.max_by(fn {:ok, _, _, seat_id} -> seat_id end)
  end

  def find_missing_seat(lines) do
    lines
    |> Enum.map(&seat_from_boarding_pass/1)
    # group into a map of row: [columns]
    |> Enum.group_by(fn {:ok, row, _, _} -> row end, &elem(&1, 2))
    # remove first and last rows
    |> Map.delete(0)
    |> Map.delete(127)
    # find a row with only 7 taken seats, find the missing one
    |> Enum.find_value(fn {row, taken_seats} ->
      if length(taken_seats) == 7 do
        missing_seat = Enum.find(0..7, &(&1 not in taken_seats))
        {:ok, row, missing_seat, row * 8 + missing_seat}
      end
    end)
  end

  def seat_from_boarding_pass(boarding_pass, seat \\ {0..127, 0..7})

  def seat_from_boarding_pass(pass, seat) when is_binary(pass) do
    pass |> to_charlist() |> seat_from_boarding_pass(seat)
  end

  def seat_from_boarding_pass([], {row..row, col..col}), do: {:ok, row, col, row * 8 + col}

  def seat_from_boarding_pass([?F | tail], {front..back, col}) do
    middle = front + div(back - front, 2)
    seat_from_boarding_pass(tail, {front..middle, col})
  end

  def seat_from_boarding_pass([?B | tail], {front..back, col}) do
    middle = front + div(back - front, 2)
    seat_from_boarding_pass(tail, {(middle + 1)..back, col})
  end

  def seat_from_boarding_pass([?L | tail], {row, left..right}) do
    middle = left + div(right - left, 2)
    seat_from_boarding_pass(tail, {row, left..middle})
  end

  def seat_from_boarding_pass([?R | tail], {row, left..right}) do
    middle = left + div(right - left, 2)
    seat_from_boarding_pass(tail, {row, (middle + 1)..right})
  end

  def seat_from_boarding_pass(pass, seat) do
    IO.inspect({:error, pass, seat})
  end
end
