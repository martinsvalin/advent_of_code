alias Advent.SecurityThroughObscurity, as: Advent04
[path] = System.argv
input = File.read!(path)

sum_of_sector_ids = input
  |> Advent04.rooms
  |> Enum.filter(&Advent04.valid_room?/1)
  |> Enum.map(& &1.sector_id)
  |> Enum.sum
IO.puts "Part 1: The sum of sector ids of real rooms are: #{sum_of_sector_ids}"
