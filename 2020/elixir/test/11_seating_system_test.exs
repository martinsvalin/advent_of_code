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
      assert ticks(1..2, @example, &Seat.line_of_sight_rules/2) ==
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

  describe "parse/1" do
    test "represents the seats as a map of positions, indicating empty or occupied" do
      assert Advent2020.lines(".L\nL#") |> Seat.parse() ==
               %{{0, 1} => :empty, {1, 0} => :empty, {1, 1} => :occupied}
    end

    test "parses the given example" do
      parsed = Advent2020.lines(@example) |> Seat.parse()
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
