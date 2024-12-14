content = File.read!("1-input1.txt")

line_values = content
|> String.split("\n")
|> Enum.map(fn line ->
  line
  |> String.split
  |> Enum.map(&String.to_integer/1)
end)

column_1_values = line_values
|> Enum.map(fn line -> line |> Enum.at(0) end)
|> Enum.filter(fn a -> a != nil end)
|> Enum.sort

column_2_values = line_values
|> Enum.map(fn line -> line |> Enum.at(1) end)
|> Enum.filter(fn a -> a != nil end)
|> Enum.sort

total_distance = column_1_values
|> Enum.zip(column_2_values)
|> Enum.map(fn {a, b} -> abs a - b end)
|> Enum.sum

IO.puts "Total distance: #{total_distance}"

similarity_score = column_1_values
|> Enum.map(fn a -> column_2_values
  |> Enum.filter(fn b -> a == b end)
  |> Enum.sum
end)
|> Enum.sum

IO.puts "Similarity score: #{similarity_score}"
