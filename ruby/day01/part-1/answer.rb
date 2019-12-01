file = File.open("./input.txt")

total_fuel = 0 
file.each do |mass|
  fuel_req = (mass.to_i / 3) - 2
  total_fuel += fuel_req
end

puts total_fuel
# 3399947