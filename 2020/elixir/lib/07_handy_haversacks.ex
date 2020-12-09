defmodule HandyHaversacks do
  import NimbleParsec

  def build_tree(lines, _tree \\ Map.new()) do
    parse(lines)
  end

  def parse(lines) do
    lines
    |> Map.new(fn
      line ->
        {:ok, [outer | inner], "", _, _, _} = bag_rule(line)

        {
          Enum.join(outer, " "),
          for [quantity | bag] <- inner do
            {Enum.join(bag, " "), quantity}
          end
        }
    end)
  end

  word = ascii_string([?a..?z], min: 1)
  bags = string("bag") |> optional(string("s")) |> ignore()
  space = string(" ") |> ignore()

  colored_bags =
    choice([word, space])
    |> repeat_while(:not_bag)
    |> concat(bags)

  def not_bag("bag" <> _, context, _, _), do: {:halt, context}
  def not_bag(_, context, _, _), do: {:cont, context}

  defparsec(
    :bag_rule,
    wrap(colored_bags)
    |> ignore(string(" contain "))
    |> repeat(
      wrap(
        choice([
          ignore(string("no other bags")),
          integer(min: 1) |> concat(colored_bags) |> ignore(string(", ")),
          integer(min: 1) |> concat(colored_bags)
        ])
      )
    )
    |> ignore(string("."))
    |> eos()
  )
end
