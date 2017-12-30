defmodule HaltingProblemTest do
  use ExUnit.Case

  describe "checksum/1" do
    test "checksum of example blueprint" do
      blueprint = TuringBlueprintTest.example_blueprint()
      assert HaltingProblem.checksum(blueprint) == 3
    end
  end
end

defmodule TuringBlueprintTest do
  use ExUnit.Case

  describe "parse/1" do
    test "parses to a representation of state behaviour" do
      assert TuringBlueprint.parse(example_blueprint()) == %{
               :begin => "A",
               :diagnostic_steps => 6,
               "A" => %{
                 0 => %{write: 1, move: "right", continue: "B"},
                 1 => %{write: 0, move: "left", continue: "B"}
               },
               "B" => %{
                 0 => %{write: 1, move: "left", continue: "A"},
                 1 => %{write: 1, move: "right", continue: "A"}
               }
             }
    end
  end

  def example_blueprint() do
    """
    Begin in state A.
    Perform a diagnostic checksum after 6 steps.
        
    In state A:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state B.
      If the current value is 1:
        - Write the value 0.
        - Move one slot to the left.
        - Continue with state B.

    In state B:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the left.
        - Continue with state A.
      If the current value is 1:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state A.
    """
  end
end
