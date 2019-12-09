defmodule UtilTest do
  use ExUnit.Case
  import Util

  test "file_contents/1" do
    assert file_contents(0) == "Input for each day\n"
  end

  test "numbers/1" do
    assert numbers("1,2,3") == [1, 2, 3]
  end
end
