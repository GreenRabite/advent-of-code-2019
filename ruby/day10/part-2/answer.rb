# file = File.open("./input.txt")
file = File.open("../part-1/input.txt")

asteroids = []

Asteroid = Struct.new(:x, :y, :count, :distance)
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
    asteroids << Asteroid.new(x, y, 0, nil) 
  end
end

def slope(p1, p2)
  (p2.y - p1.y).to_f / (p2.x - p1.x)
end

# p2 is reference point
def arctan(p1, p2)
  # atan2(y, x) → Float
  Math.atan2((p2.y - p1.y), (p2.x - p1.x))
end

def distance(p1, p2)
  Math.sqrt(sum_of_squares(p1,p2).to_f)
end

def sum_of_squares(p1,p2)
  ((p2.x - p1.x) ** 2) + ((p2.y - p1.y) ** 2)
end

seen_asteroids = []
slopes = {}

asteroids.each do |asteroid|
  asteroid_distance_hash = {}
  
  (asteroids-[asteroid]).each do |other_asteroid|
    if asteroid_distance_hash["#{arctan(asteroid, other_asteroid)}"].nil?
      asteroid_distance_hash["#{arctan(asteroid, other_asteroid)}"] = distance(other_asteroid, asteroid)
    elsif asteroid_distance_hash["#{arctan(asteroid, other_asteroid)}"] && distance(other_asteroid, asteroid) < asteroid_distance_hash["#{arctan(asteroid, other_asteroid)}"]
      asteroid_distance_hash["#{arctan(asteroid, other_asteroid)}"] = distance(other_asteroid, asteroid)
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

#part-2
install_laser = seen_asteroids.sort_by {|x| x.count}.reverse.first
quadrant_hash = Hash.new { |h, k| h[k] = [] }

(asteroids - [install_laser]).each do |asteroid|
  asteroid.distance = distance(asteroid, install_laser)
  raw_degree = arctan(asteroid, install_laser) * (360/(2 * Math::PI))
  # shifted so that NORTH is now 0 degrees
  degree = raw_degree >= 0 ? raw_degree : 360 + raw_degree
  convert_degree = degree >= 90 ? degree - 90 : degree + 270
  quadrant_hash[convert_degree] << asteroid
end

quadrant_hash.each do |k,v|
  v.sort! {|x,y| x.distance <=> y.distance}
end

# p quadrant_hash.select {|k,v| v.length > 4}


counter = 0
result = []
loop do
  quadrant_hash.keys.sort.each do |key|
    
    if quadrant_hash[key].length > 0
      counter +=1
      # p counter
      result << quadrant_hash[key].first if counter == 200
      quadrant_hash[key].shift
    end
    break if counter >= 200
  end
  break if counter >= 200
end

p result.length
p result.first
p result.first.x * 100 + result.first.y





