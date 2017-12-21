defmodule ASeriesOfTubesTest do
  use ExUnit.Case
  import ASeriesOfTubes

  @sample """
      |          
      |  +--+    
      A  |  C    
  F---|----E|--+ 
      |  |  |  D 
      +B-+  +--+ 
  """

  describe "waypoints/1" do
    test "returns the waypoints in order along the path, and the steps" do
      assert waypoints(@sample) == {:done, "ABCDEF", 38}
    end
  end
end
