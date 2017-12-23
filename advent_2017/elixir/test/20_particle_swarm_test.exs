defmodule ParticleSwarmTest do
  use ExUnit.Case
  import ParticleSwarm

  describe "stays_closest/1" do
    test "unique lowest acceleration always wins" do
      input = """
      p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>
      p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
      p=< 3,0,0>, v=< 2,0,0>, a=< 5,0,0>
      """

      assert stays_closest(input) == 1
    end

    test "tie breaks on lower velocity" do
      input = """
      p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>
      p=< 3,0,0>, v=< 2,0,0>, a=< 1,0,0>
      p=< 3,0,0>, v=< 1,0,0>, a=< 1,0,0>
      """

      assert stays_closest(input) == 2
    end

    test "consider acceleration that lowers velocity" do
      input = """
      p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>
      p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
      p=< 3,0,0>, v=< 1,0,0>, a=< 1,0,0>
      """

      assert stays_closest(input) == 1
    end

    test "among particles with no acceleration, lowest velocity wins" do
      input = """
      p=< 4,0,0>, v=< 0,0,0>, a=<0,0,0>
      p=< 3,0,0>, v=< 2,0,0>, a=<0,0,0>
      p=< 3,0,0>, v=< 1,0,0>, a=<0,0,0>
      """

      assert stays_closest(input) == 0
    end

    test "among stationary particles, closest distance wins" do
      input = """
      p=< 4,0,0>, v=< 0,0,0>, a=<0,0,0>
      p=< 3,0,0>, v=< 0,0,0>, a=<0,0,0>
      p=< 2,0,0>, v=< 0,0,0>, a=<0,0,0>
      """

      assert stays_closest(input) == 2
    end
  end
end
