defmodule RocketEquationTest do
  use ExUnit.Case
  import RocketEquation

  test "sum_fuel_requirements/1" do
    assert sum_fuel_requirements([12, 14, 1969, 100_756]) == 2 + 2 + 654 + 33583
  end

  describe "mass_fuel_requirements/1" do
    test "basic correctness" do
      assert mass_fuel_requirements(12) == 2
      assert mass_fuel_requirements(14) == 2
      assert mass_fuel_requirements(1969) == 654
      assert mass_fuel_requirements(100_756) == 33583
    end

    test "negative values mean zero" do
      assert mass_fuel_requirements(6) == 0
    end
  end

  test "total_fuel_requirements/1 includes fuel for added fuel" do
    assert total_fuel_requirements([12, 14, 1969, 100_756]) == 2 + 2 + 966 + 50346
  end

  test "fuel_requirements_accouting_for_more_fuel/1" do
    assert fuel_requirements_accouting_for_more_fuel(14) == 2
    assert fuel_requirements_accouting_for_more_fuel(1969) == 966
    assert fuel_requirements_accouting_for_more_fuel(100_756) == 50346
  end
end
