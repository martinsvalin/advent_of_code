defmodule TicketTranslationTest do
  use ExUnit.Case
  alias TicketTranslation, as: TT

  @example """
  class: 1-3 or 5-7
  row: 6-11 or 33-44
  seat: 13-40 or 45-50

  your ticket:
  7,1,14

  nearby tickets:
  7,3,47
  40,4,50
  55,2,20
  38,6,12
  """

  describe "scanning_error/1" do
    test "with the given example" do
      assert TT.scanning_error(@example) == 71
    end
  end

  @example2 """
  class: 0-1 or 4-19
  row: 0-5 or 8-19
  seat: 0-13 or 16-19

  your ticket:
  11,12,13

  nearby tickets:
  3,9,18
  15,1,5
  5,14,9
  """

  describe "determine_fields/1" do
    test "with the given example" do
      assert TT.determine_fields(@example2) == [
               "row",
               "class",
               "seat"
             ]
    end
  end

  describe "invalid/2 gives invalid numbers from tickets" do
    @rules TT.parse(Advent2020.lines(@example)).rules

    test "with a valid ticket: 7,3,47" do
      assert TT.invalid([7, 3, 47], @rules) == []
    end

    test "an invalid ticket: 40,4,50" do
      assert TT.invalid([40, 4, 50], @rules) == [4]
    end
  end

  describe "parse/1" do
    test "splits input into rules, your ticket, nearby tickets" do
      assert TT.parse(Advent2020.lines(@example)) ==
               %{
                 rules: %{
                   "class" => {1..3, 5..7},
                   "row" => {6..11, 33..44},
                   "seat" => {13..40, 45..50}
                 },
                 your_ticket: [7, 1, 14],
                 nearby_tickets: [
                   [7, 3, 47],
                   [40, 4, 50],
                   [55, 2, 20],
                   [38, 6, 12]
                 ]
               }
    end
  end
end
