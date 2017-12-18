defmodule DuetTest do
  use ExUnit.Case
  import Duet

  @example_input """
    set a 1
    add a 2
    mul a a
    mod a 5
    snd a
    set a 0
    rcv a
    jgz a -1
    set a 1
    jgz a -2  
  """

  describe "recover_frequency/1" do
    test "it returns the last played sound" do
      assert recover_frequency(@example_input) == 4
    end
  end
end
