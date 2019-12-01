defmodule RocketEquation do
  @moduledoc """
  # Day 1: The Tyranny of the Rocket Equation

  https://adventofcode.com/2019/day/1

  ## Part 1: Sum the fuel requirements of all the modules

  Take each module's mass divided by three, round down, and subtract 2.

  ## Part 2: Include fuel for the fuel, and for its fuel etc

  Use the same formula for calculating fuel requirements, but each time you add
  a positive amount of fuel, add more fuel to account for it.
  Negative fuel requirements are treated as zero.
  """

  @doc "Fuel requirements for all module masses"
  @spec sum_fuel_requirements([integer()]) :: integer()
  def sum_fuel_requirements(module_masses) do
    Enum.reduce(module_masses, 0, &(mass_fuel_requirements(&1) + &2))
  end

  @doc "Fuel requirements for a given mass"
  @spec mass_fuel_requirements(integer()) :: non_neg_integer()
  def mass_fuel_requirements(mass) do
    max(div(mass, 3) - 2, 0)
  end

  @doc "Fuel requirements for all module masses, including the added fuel"
  @spec total_fuel_requirements([integer()]) :: integer()
  def total_fuel_requirements(module_masses) do
    Enum.reduce(module_masses, 0, &(fuel_requirements_accouting_for_more_fuel(&1) + &2))
  end

  @doc "Fuel requirements for a given mass, accounting for the added fuel recursively"
  @spec fuel_requirements_accouting_for_more_fuel(integer()) :: integer()
  def fuel_requirements_accouting_for_more_fuel(added_mass, sum \\ 0)
  def fuel_requirements_accouting_for_more_fuel(0, sum), do: sum

  def fuel_requirements_accouting_for_more_fuel(added_mass, sum) do
    more_fuel = mass_fuel_requirements(added_mass)
    fuel_requirements_accouting_for_more_fuel(more_fuel, sum + more_fuel)
  end
end
