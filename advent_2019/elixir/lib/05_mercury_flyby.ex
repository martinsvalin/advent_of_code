defmodule MercuryFlyby do
  @moduledoc """
  # Day 5: Sunny with a Chance of Asteroids

  Run a diagnostic program (Intcode) for the air conditioner. Your Intcode
  computer needs to be upgraded with new instructions and parameter modes.

  Two new instructions need implementing for part 1. Input (3) and output (4).
  They both take a single parameter for the address of where to write the input,
  or the value to output.

  Parameter modes are given with the instruction. The two least significant
  numbers (tens, ones) give the operation, and the hundreds, thousands etc are
  parameter modes. The first parameter is given its mode in the hundreds, the
  second in the thousands etc. Leading zeroes are implied.

  Parameter mode 0 is for position mode, where the parameter value means the
  address of where the value should be read. Parameter mode 1 is for immediate
  mode, where the parameter value should be used directly.
  """

  @day 5

  @doc """
  Part 1: what diagnostic code does the program produce?

  There will be one input instruction, which will be given a 1.
  The diagnostic code is the value of the last output command.
  """
  def part1() do
    [{_line, diagnostic_code} | _] = Intcode.run(Util.numbers(@day), [1]).outputs
    diagnostic_code
  end

  @doc """
  Part 2: what is the diagnostic code for system ID 5?
  """
  def part2() do
    [{_line, diagnostic_code}] = Intcode.run(Util.numbers(@day), [5]).outputs
    diagnostic_code
  end
end
