defmodule Util do
  def file_contents(day) when is_integer(day) do
    file_contents(String.pad_leading(to_string(day), 2, "0") <> ".txt")
  end

  def file_contents(filename) do
    Path.join([__DIR__, "..", "inputs", filename])
    |> File.read!()
  end

  def lines(day) when is_integer(day) do
    file_contents(day) |> lines()
  end

  def lines(file_contents) when is_binary(file_contents) do
    file_contents |> String.split("\n", trim: true)
  end

  def numbers(day) when is_integer(day), do: day |> file_contents() |> numbers()

  def numbers(file_contents) when is_binary(file_contents) do
    file_contents
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
