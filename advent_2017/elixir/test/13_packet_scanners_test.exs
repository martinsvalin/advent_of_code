defmodule PacketScannersTest do
  use ExUnit.Case

  @simple """
    0: 3
    1: 2
    4: 4
    6: 4
  """

  describe "total_severity/1" do
    test "for a simple case" do
      assert PacketScanners.total_severity(@simple) == 24
    end
  end

  describe "total_severity/2" do
    test "for the same case with a 10 picosecond delay" do
      assert PacketScanners.total_severity(@simple, 10) == 0
    end
  end
end
