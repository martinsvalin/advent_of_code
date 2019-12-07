defmodule Util do
  def file_contents(day) do
    filename = String.pad_leading(to_string(day), 2, "0") <> ".txt"
    path = Path.join([__DIR__, "..", "inputs", filename])
    File.read!(path)
  end

  def lines(day) do
    file_contents(day) |> String.split("\n", trim: true)
  end

  def numbers(lines) do
    Enum.map(lines, &String.to_integer/1)
  end
end
