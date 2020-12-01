# Advent2020

Elixir solutions for Advent of Code 2020.
All puzzles are available at https://adventofcode.com/2020/

This year, I'll generally expose functions that solve the puzzle but may
need some assembly in the REPL. My process is to work out the solution
with the help of REPL and tests, and if there is some trivial step I might
do that manually in the REPL.

For example, to solve Day 1, part 1, fire up the repl with `iex -S mix`, then:

    iex> Advent2020.numbers(1) |> ReportRepair.find_two_with_sum
    {:ok, 954, 1066}
    iex> 954 * 1066
    1016964
