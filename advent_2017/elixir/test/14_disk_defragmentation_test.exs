defmodule DiskDefragmentationTest do
  use ExUnit.Case
  @moduletag :slow

  describe "count_used/1" do
    test "given test case" do
      assert DiskDefragmentation.count_used("flqrgnkx") === 8108
    end
  end

  describe "count_regions/1" do
    test "given test case" do
      assert DiskDefragmentation.count_regions("flqrgnkx") === 1242
    end
  end
end
