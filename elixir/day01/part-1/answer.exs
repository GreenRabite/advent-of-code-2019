# file = File.read("./input.txt")

sample = File.read!("./input.txt") |> String.split |> Enum.map(&String.to_integer/1)
IO.inspect sample

# IO.puts Enum.reduce(contents, fn x, acc -> acc + Integer.floor(String.to_integer(x) / 3) - 2 end) 

# total_fuel = 0 
# file.each do |mass|
#   fuel_req = (mass.to_i / 3) - 2
#   total_fuel += fuel_req
# end

# puts total_fuel
# 3399947