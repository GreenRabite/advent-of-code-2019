# file = File.open("./input.txt")
file = File.open("./input.txt")

asteroids = []

Asteroid = Struct.new(:x, :y, :count)
# Structure of Map
# 0 1 2 3 4 5 -> x
# 1
# 2
# 3
# 4
# 5
# |
# y

file.each_with_index do |row, y|
  row.split("").map.with_index do |value, x|
    next if value != '#'
    asteroids << Asteroid.new(x, y, 0) 
  end
end

def slope(p1, p2)
  (p2.y - p1.y).to_f / (p2.x - p1.x)
end

def distance(p1, p2)
  Math.sqrt(sum_of_squares(p1,p2).to_f)
end

def sum_of_squares(p1,p2)
  ((p2.x - p1.x) ** 2) + ((p2.y - p1.y) ** 2)
end

# p2 is the main reference, p1 is the other asteroid
def quadrant(p1,p2)
  if p2.y > p1.y && p2.x > p1.x
    'NorthWest'
  elsif p2.y < p1.y && p2.x < p1.x
    'SouthEast'
  elsif p2.y > p1.y && p2.x < p1.x
    'NorthEast'
  elsif p2.y < p1.y && p2.x > p1.x
    'SouthWest'
  elsif p2.y == p1.y && p2.x > p1.x
    'West'
  elsif p2.y == p1.y && p2.x < p1.x
    'East'
  elsif p2.x == p1.x && p2.y > p1.y
    'North'
  elsif p2.x == p1.x && p2.y < p1.y
    'South'
  end
end


seen_asteroids = []
slopes = {}

asteroids.each do |asteroid|
  asteroid_distance_hash = {}
  
  (asteroids-[asteroid]).each do |other_asteroid|
    if asteroid_distance_hash["#{quadrant(other_asteroid, asteroid)}#{slope(other_asteroid, asteroid)}"].nil?
      asteroid_distance_hash["#{quadrant(other_asteroid, asteroid)}#{slope(other_asteroid, asteroid)}"] = distance(other_asteroid, asteroid)
    elsif asteroid_distance_hash["#{quadrant(other_asteroid, asteroid)}#{slope(other_asteroid, asteroid)}"] && distance(other_asteroid, asteroid) < asteroid_distance_hash["#{quadrant(other_asteroid, asteroid)}#{slope(other_asteroid, asteroid)}"]
      asteroid_distance_hash["#{quadrant(other_asteroid, asteroid)}#{slope(other_asteroid, asteroid)}"] = distance(other_asteroid, asteroid)
    end
  end
  
  slopes["#{asteroid.x},#{asteroid.y}"] = asteroid_distance_hash
  asteroid.count = asteroid_distance_hash.values.count
  seen_asteroids << asteroid
end
#part-1
p seen_asteroids.sort_by {|x| x.count}.reverse.first
# Asteroid [26,36]
# 347







