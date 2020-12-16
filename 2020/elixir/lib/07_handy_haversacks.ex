defmodule HandyHaversacks do
  import NimbleParsec

  def part1(lines \\ Advent2020.lines(7)) do
    lines
    |> build_tree()
    |> bags_that_can_contain("shiny gold")
    |> length
  end

  def part2(lines \\ Advent2020.lines(7)) do
    lines
    |> build_tree()
    |> bags_in_my_bag({"shiny gold", 1})
    |> count_bags()
    |> Kernel.+(-1)
  end

  def build_tree(lines, _tree \\ Map.new()) do
    graph = :digraph.new()

    for {outer_bag, inner_bags} <- parse(lines) do
      :digraph.add_vertex(graph, outer_bag)

      for {inner_bag, quantity} <- inner_bags do
        :digraph.add_vertex(graph, inner_bag)
        :digraph.add_edge(graph, outer_bag, inner_bag, quantity)
      end
    end

    graph
  end

  def bags_that_can_contain(graph, bag) do
    :digraph_utils.reaching_neighbours([bag], graph)
  end

  def bags_in_my_bag(graph, {bag, count}) do
    inner =
      :digraph.out_edges(graph, bag)
      |> Enum.map(fn edge ->
        {_, ^bag, inner_bag, quantity} = :digraph.edge(graph, edge)
        {inner_bag, quantity}
      end)
      |> Enum.map(&bags_in_my_bag(graph, &1))

    {bag, count, inner}
  end

  def count_bags({_, quantity, []}), do: quantity

  def count_bags({_, quantity, inner_bags}) do
    quantity + quantity * Enum.sum(Enum.map(inner_bags, &count_bags/1))
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

  ## defining a parser

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
