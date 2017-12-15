defmodule DuelingGeneratorsTest do
  use ExUnit.Case
  import DuelingGenerators

  @seed_a 65
  @seed_b 8921

  describe "count_matching_low16/3 with unfiltered generators" do
    setup do: %{gen_a: generator_a(@seed_a), gen_b: generator_b(@seed_b)}

    test "with unfiltered generators", %{gen_a: a, gen_b: b} do
      assert count_matching_low16(a, b, 5) == 1
    end

    @tag :slow
    test "generating 40 million values", %{gen_a: a, gen_b: b} do
      assert count_matching_low16(a, b, 40_000_000) == 588
    end
  end

  describe "count_matching_low16/3 with filtered generators" do
    setup do: %{gen_a: filtered_generator_a(@seed_a), gen_b: filtered_generator_b(@seed_b)}

    test "generating a few values with filtered generators", %{gen_a: a, gen_b: b} do
      assert count_matching_low16(a, b, 5) == 0
    end

    @tag :slow
    test "generating a 5 million values", %{gen_a: a, gen_b: b} do
      assert count_matching_low16(a, b, 5_000_000) == 309
    end
  end
end
