{:ok, input} = File.read "../input.txt"

count = fn list, char ->
  Enum.count(list, &(&1 == <<char>>))
end

count_ups_and_downs = &( {count.(&1, ?(), count.(&1, ?))} )

{up, down} = input
|> String.codepoints
|> count_ups_and_downs.()

IO.puts "Santa is going to floor #{up - down}"
