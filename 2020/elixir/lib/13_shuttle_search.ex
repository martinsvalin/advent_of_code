defmodule ShuttleSearch do
  def nearest_departure_time([earliest, timetable]) do
    earliest = String.to_integer(earliest)

    timetable
    |> buses_with_index()
    |> Enum.map(fn {_, bus} ->
      time =
        Stream.iterate(bus, &(&1 + bus))
        |> Stream.drop_while(&(&1 < earliest))
        |> Enum.at(0)

      {time, bus, bus * (time - earliest)}
    end)
    |> Enum.min()
  end

  def win_the_contest_by_search([_, timetable]),
    do: win_the_contest_by_search(timetable)

  def win_the_contest_by_search(timetable) do
    buses = buses_with_index(timetable)
    {index, slowest} = Enum.max_by(buses, &elem(&1, 1))

    slowest
    |> Stream.iterate(&(&1 + slowest))
    |> Enum.find(fn time ->
      Enum.all?(buses, fn {i, bus} -> rem(time - index + i, bus) == 0 end) ||
        time > 100_000_000_000
    end)
    |> Kernel.-(index)
  end

  def win_the_contest_by_sieve([_, timetable]),
    do: win_the_contest_by_sieve(timetable)

  def win_the_contest_by_sieve(timetable) do
    timetable
    |> buses_with_remainder()
    |> Enum.reduce(&find_solution/2)
    |> elem(0)
  end

  def find_solution({rem, bus}, {x, modulo}) do
    new_x =
      Stream.iterate(x, &(&1 + modulo))
      |> Enum.find(&(rem(&1, bus) == rem))

    {new_x, bus * modulo}
  end

  def buses_with_index(timetable) do
    for {{n, ""}, i} <-
          String.split(timetable, ",")
          |> Enum.map(&Integer.parse/1)
          |> Enum.with_index(),
        do: {i, n}
  end

  def buses_with_remainder(timetable) do
    timetable
    |> buses_with_index()
    |> Enum.sort_by(&elem(&1, 1), :desc)
    |> Enum.map(fn {i, bus} ->
      {rem(bus - rem(i, bus), bus), bus}
    end)
  end
end
