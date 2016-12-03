defmodule Util do
  @moduledoc false

  @doc """
  Invert a map. Does not handle duplicate values.

  ## Examples

      iex> Util.invert_map(%{a: 1, b: 2})
      %{1 => :a, 2 => :b}
  """
  def invert_map(map) when is_map(map) do
    for {x,y} <- map, into: Map.new, do: {y,x}
  end
end
