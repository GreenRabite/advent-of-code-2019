file = File.open("../part-1/input.txt")

def calculate_fuel(mass, running_count = 0)
  fuel = (mass / 3) - 2
  return running_count if fuel <= 0
  calculate_fuel(fuel, running_count + fuel)
end

fuel_req = 0
file.each do |mass|
  fuel_req += calculate_fuel(mass.to_i)
end

puts fuel_req
# 5097039