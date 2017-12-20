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

  test "running two programs concurrently" do
    test_two_programs(input: @example_input, expectations: [{0, 1}, {1, 1}])
  end

  test "running two programs on my puzzle input" do
    test_two_programs(input: File.read!("inputs/18.txt"), expectations: [{0, 7366}, {1, 7239}])
  end

  def test_two_programs(input: input, expectations: expectations) do
    ops = Duet.ops(input)
    {:ok, d0} = Duet.Server.start(0, ops)
    {:ok, d1} = Duet.Server.start(1, ops)

    Duet.Server.solve(d0, other: d1)
    Duet.Server.solve(d1, other: d0)

    Enum.map(expectations, fn {id, sent_count} -> assert_receive({^id, ^sent_count, _}) end)
  end
end
