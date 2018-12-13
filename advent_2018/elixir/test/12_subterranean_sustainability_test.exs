defmodule SubterraneanSustainabilityTest do
  use ExUnit.Case
  import SubterraneanSustainability

  @example_rules %{
    "...##" => ?#,
    "..#.." => ?#,
    ".#..." => ?#,
    ".#.#." => ?#,
    ".#.##" => ?#,
    ".##.." => ?#,
    ".####" => ?#,
    "#.#.#" => ?#,
    "#.###" => ?#,
    "##.#." => ?#,
    "##.##" => ?#,
    "###.." => ?#,
    "###.#" => ?#,
    "####." => ?#
  }
  @example_pots "#..#.#..##......###...###"
  @example_state %{
    pots: @example_pots,
    offset: 0,
    generation: 0,
    rules: @example_rules
  }

  doctest SubterraneanSustainability

  describe "tick/3" do
    test "works" do
      assert tick(@example_state).pots == "#...#....#.....#..#..#..#"
    end

    test "adjusts offset" do
      gen3 = @example_state |> tick() |> tick() |> tick()
      assert gen3.pots == "#.#...#..#.#....#..#..#...#"
      assert gen3.offset == -1
    end
  end

  @tag :focus
  describe "sum_pot_numbers/1" do
    test "works" do
      gen20 = run(@example_state, 20)
      assert sum_pot_numbers(gen20) == 325
    end
  end
end
