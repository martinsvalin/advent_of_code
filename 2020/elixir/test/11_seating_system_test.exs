defmodule SeatingSystemTest do
  use ExUnit.Case

  alias SeatingSystem, as: Seat

  @example """
  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL
  """

  describe "stabilize/1" do
    test "ticks forward until seating is stable" do
      assert Seat.stabilize("""
             L..
             .L.
             ..L
             """)
             |> Seat.to_string() ==
               """
               #..
               .#.
               ..#
               """
    end

    test "given example stops after five ticks" do
      assert Seat.stabilize(@example) |> Seat.to_string() ==
               ticks(1..5, @example)
    end
  end

  describe "tick/2 with simple rules applied, looking only at immediate neighbours" do
    test "empty seats that have no adjacent occupied seats become occupied" do
      assert tick("""
             L..
             .L.
             ..L
             """) ==
               """
               #..
               .#.
               ..#
               """
    end

    test "occupied seats with four adjacent occupied seats become empty" do
      assert tick("""
             #.#
             .#.
             #.#
             """) ==
               """
               #.#
               .L.
               #.#
               """
    end

    test "given example, after one tick" do
      assert @example |> tick() == """
             #.##.##.##
             #######.##
             #.#.#..#..
             ####.##.##
             #.##.##.##
             #.#####.##
             ..#.#.....
             ##########
             #.######.#
             #.#####.##
             """
    end

    test "given example, after two ticks" do
      assert @example |> tick() |> tick() == """
             #.LL.L#.##
             #LLLLLL.L#
             L.L.L..L..
             #LLL.LL.L#
             #.LL.LL.LL
             #.LLLL#.##
             ..L.L.....
             #LLLLLLLL#
             #.LLLLLL.L
             #.#LLLL.##
             """
    end

    test "given example, after three ticks" do
      assert @example |> tick() |> tick() |> tick() == """
             #.##.L#.##
             #L###LL.L#
             L.#.#..#..
             #L##.##.L#
             #.##.LL.LL
             #.###L#.##
             ..#.#.....
             #L######L#
             #.LL###L.L
             #.#L###.##
             """
    end

    test "given example, after four ticks" do
      assert ticks(1..4, @example) == """
             #.#L.L#.##
             #LLL#LL.L#
             L.L.L..#..
             #LLL.##.L#
             #.LL.LL.LL
             #.LL#L#.##
             ..L.L.....
             #L#LLLL#L#
             #.LLLLLL.L
             #.#L#L#.##
             """
    end

    test "given example, after five ticks" do
      assert ticks(1..5, @example) == """
             #.#L.L#.##
             #LLL#LL.L#
             L.#.L..#..
             #L##.##.L#
             #.#L.LL.LL
             #.#L#L#.##
             ..L.L.....
             #L#L##L#L#
             #.LLLLLL.L
             #.#L#L#.##
             """
    end

    test "given example, five ticks is stable" do
      assert ticks(1..5, @example) == ticks(1..6, @example)
    end
  end

  describe "tick/2 with line-of-sight rules applied" do
    test "given example looks a bit different two ticks in" do
      rules = &Seat.line_of_sight_rules/2

      assert @example |> tick(rules) |> tick(rules) ==
               """
               #.LL.LL.L#
               #LLLLLL.LL
               L.L.L..L..
               LLLL.LL.LL
               L.LL.LL.LL
               L.LLLLL.LL
               ..L.L.....
               LLLLLLLLL#
               #.LLLLLL.L
               #.LLLLL.L#
               """
    end
  end

  describe "line_of_sight_rules/2" do
    test "occupied, with 6 visible occupied seats" do
      seats =
        Seat.parse("""
        #.#.L
        .....
        #.#.L
        .....
        #.#.#
        """)

      assert Seat.line_of_sight_rules({{2, 2}, :occupied}, seats) == {{2, 2}, :empty}
    end

    test "occupied, with 5 visible occupied seats" do
      seats =
        Seat.parse("""
        #.#.L
        .....
        #.#.L
        .....
        #.#.#
        """)

      assert Seat.line_of_sight_rules({{0, 2}, :occupied}, seats) == {{0, 2}, :empty}
    end

    test "occupied, with 4 visible occupied seats" do
      seats =
        Seat.parse("""
        #.#.L
        .....
        #.#.L
        .....
        #.#.#
        """)

      assert Seat.line_of_sight_rules({{4, 2}, :occupied}, seats) == {{4, 2}, :occupied}
    end

    test "occupied, with 3 visible occupied seats" do
      seats =
        Seat.parse("""
        #.#.L
        .....
        #.#.L
        .....
        #.#.#
        """)

      assert Seat.line_of_sight_rules({{0, 0}, :occupied}, seats) == {{0, 0}, :occupied}
    end

    test "occupied, with 2 visible occupied seats" do
      seats =
        Seat.parse("""
        #.#.L
        .....
        #.#.L
        .....
        #.#.#
        """)

      assert Seat.line_of_sight_rules({{4, 4}, :occupied}, seats) == {{4, 4}, :occupied}
    end

    test "free, with 0 visible occupied seats" do
      seats =
        Seat.parse("""
        #.#.L
        ....L
        #.#.L
        .....
        #.#.#
        """)

      assert Seat.line_of_sight_rules({{4, 1}, :empty}, seats) == {{4, 1}, :occupied}
    end
  end

  describe "parse/1" do
    test "represents the seats as a map of positions, indicating empty or occupied, paired with max position" do
      assert Advent2020.lines(".L\nL#") |> Seat.parse() ==
               {%{{0, 1} => :empty, {1, 0} => :empty, {1, 1} => :occupied}, {2, 2}}
    end

    test "parses the given example" do
      {parsed, {10, 10}} = Advent2020.lines(@example) |> Seat.parse()
      assert map_size(parsed) == 71
      assert Map.values(parsed) |> Enum.all?(&(&1 == :empty))
    end
  end

  def tick(string, rules \\ &Seat.simple_rules/2) do
    string |> Advent2020.lines() |> Seat.parse() |> Seat.tick(rules) |> Seat.to_string()
  end

  def ticks(_.._ = range, initial, rules \\ &Seat.simple_rules/2) do
    Enum.reduce(range, initial, fn _, seats -> tick(seats, rules) end)
  end
end
