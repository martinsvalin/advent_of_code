defmodule HandyHaversacksTest do
  use ExUnit.Case
  alias HandyHaversacks, as: Handy

  @example [
    "light red bags contain 1 bright white bag, 2 muted yellow bags.",
    "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
    "bright white bags contain 1 shiny gold bag.",
    "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
    "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
    "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
    "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
    "faded blue bags contain no other bags.",
    "dotted black bags contain no other bags."
  ]

  describe "count_outer_bags/2" do
  end

  describe "parse/1" do
    test "red bags contain 1 blue bag" do
      assert Handy.parse(["red bags contain 1 blue bag."]) ==
               %{"red" => [{"blue", 1}]}
    end

    test "peach flavoured bags contain 123 mango apple bags" do
      assert Handy.parse(["peach flavoured bags contain 123 mango apple bags."]) ==
               %{"peach flavoured" => [{"mango apple", 123}]}
    end

    test "black bags contain no other bags" do
      assert Handy.parse(["black bags contain no other bags."]) ==
               %{"black" => []}
    end

    test "given example" do
      assert Handy.parse(@example) ==
               %{
                 "light red" => [{"bright white", 1}, {"muted yellow", 2}],
                 "dark orange" => [{"bright white", 3}, {"muted yellow", 4}],
                 "bright white" => [{"shiny gold", 1}],
                 "muted yellow" => [{"shiny gold", 2}, {"faded blue", 9}],
                 "shiny gold" => [{"dark olive", 1}, {"vibrant plum", 2}],
                 "dark olive" => [{"faded blue", 3}, {"dotted black", 4}],
                 "vibrant plum" => [{"faded blue", 5}, {"dotted black", 6}],
                 "faded blue" => [],
                 "dotted black" => []
               }
    end
  end
end
