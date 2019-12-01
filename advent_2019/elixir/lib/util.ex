defmodule Util do
  def file_contents(day) do
    filename = String.pad_leading(to_string(day), 2, "0") <> ".txt"
    path = Path.join([__DIR__, "..", "inputs", filename])
    File.read!(path)
  end

  def numbers(file_contents) do
    file_contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
