alias Advent.BalanceBots, as: Advent10
alias Advent.Bot
[path] = System.argv
input = File.read!(path) |> String.strip

Advent10.run(input)
[part_1_bot] = Advent10.who_compared(61, 17)
part_2_product = Bot.current(Bot.pid("output 0")) * Bot.current(Bot.pid("output 1")) * Bot.current(Bot.pid("output 2"))

IO.puts "Part 1: chips 61 and 17 were compared by: #{part_1_bot}"
IO.puts "Part 2: the product of what's in outputs 0, 1 and 2 is: #{part_2_product}"
