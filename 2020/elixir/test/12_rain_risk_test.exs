defmodule RainRiskTest do
  use ExUnit.Case

  @example ~w(F10 N3 F7 R90 F11)

  describe "navigate_ship/2" do
    test "moving east" do
      assert {17, 0, :east} == RainRisk.navigate_ship(~w(E17))
      assert {7, 10, :east} == RainRisk.navigate_ship(~w(E17), {-10, 10, :east})
      assert {7, 10, :north} == RainRisk.navigate_ship(~w(E17), {-10, 10, :north})
    end

    test "moving north" do
      assert {0, 30, :east} == RainRisk.navigate_ship(~w(N30))
      assert {1, 29, :east} == RainRisk.navigate_ship(~w(N30), {1, -1, :east})
      assert {1, 29, :south} == RainRisk.navigate_ship(~w(N30), {1, -1, :south})
    end

    test "moving west" do
      assert {-17, 0, :east} == RainRisk.navigate_ship(~w(W17))
      assert {-27, 5, :east} == RainRisk.navigate_ship(~w(W17), {-10, 5, :east})
      assert {-27, 5, :west} == RainRisk.navigate_ship(~w(W17), {-10, 5, :west})
    end

    test "moving south" do
      assert {0, -12, :east} == RainRisk.navigate_ship(~w(S12))
      assert {-4, 28, :east} == RainRisk.navigate_ship(~w(S12), {-4, 40, :east})
      assert {-4, 28, :north} == RainRisk.navigate_ship(~w(S12), {-4, 40, :north})
    end

    test "moving forward" do
      assert {82, 0, :east} == RainRisk.navigate_ship(~w(F82))
      assert {95, 33, :east} == RainRisk.navigate_ship(~w(F82), {13, 33, :east})
      assert {13, -49, :south} == RainRisk.navigate_ship(~w(F82), {13, 33, :south})
    end

    test "turning left" do
      assert {0, 0, :north} == RainRisk.navigate_ship(~w(L90))
      assert {13, 33, :west} == RainRisk.navigate_ship(~w(L180), {13, 33, :east})
      assert {13, 33, :west} == RainRisk.navigate_ship(~w(L270), {13, 33, :south})
    end

    test "given example" do
      assert {17, -8, :south} == RainRisk.navigate_ship(@example)
    end
  end

  describe "navigate_by_waypoint/3" do
    test "given example" do
      assert {214, -72} = RainRisk.navigate_by_waypoint(@example)
    end
  end

  test "distance/1 gives the manhattan distance" do
    assert RainRisk.distance({10, 5, :east}) == 15
    assert RainRisk.distance({10, -5, :south}) == 15
  end
end
