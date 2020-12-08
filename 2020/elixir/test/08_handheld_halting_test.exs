defmodule HandheldHaltingTest do
  use ExUnit.Case

  @program """
           nop +0
           acc +1
           jmp +4
           acc +3
           jmp -3
           acc -99
           acc +1
           jmp -4
           acc +6
           """
           |> String.split("\n", trim: true)

  describe "detect_infinite_loop/1" do
    test "given a program that loops forever, halt and inspect program state before it loops" do
      assert HandheldHalting.detect_infinite_loop(@program) == {:loop, 1, 5}
    end
  end

  describe "repair_program/1" do
    test "it finds a line where, if nop is changed to jmp or vice versa, the program works" do
      assert HandheldHalting.repair_program(@program) == {:exit, length(@program), 8}
    end
  end

  describe "mutate/1" do
    test "it produces programs where a single jmp or nop instruction has been replaced" do
      assert HandheldHalting.mutate(%{0 => {:acc, 1}, 1 => {:jmp, 1}, 2 => {:nop, 1}}) ==
               [
                 %{0 => {:acc, 1}, 1 => {:jmp, 1}, 2 => {:jmp, 1}},
                 %{0 => {:acc, 1}, 1 => {:nop, 1}, 2 => {:nop, 1}},
                 %{0 => {:acc, 1}, 1 => {:jmp, 1}, 2 => {:nop, 1}}
               ]
    end
  end
end
