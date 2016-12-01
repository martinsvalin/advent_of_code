alias Advent.BlocksToHq, as: Blocks

positions = File.read!("#{__DIR__}/input.txt")
|> Blocks.follow_instructions

part1_distance = Blocks.distance_from_start(hd positions)
IO.puts "Part 1: The distance to HQ is #{part1_distance}"

part2_distance = positions
  |> Enum.reverse
  |> Blocks.first_visited_twice
  |> Blocks.distance_from_start
IO.puts "Part 2: The distance to the first location visited twice is #{part2_distance}"
