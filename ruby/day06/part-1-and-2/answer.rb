file = File.open("./input.txt")
# file="COM)B,B)C,C)D,D)E,E)F,B)G,G)H,D)I,E)J,J)K,K)L".split(",")

class Planet
  attr_accessor :orbits, :name

  def initialize(name)
    @name = name
    @orbits = nil
  end

  def count_orbits(count=0)
    return count if orbits.nil?
    new_count = count + 1
    orbits.count_orbits(new_count)
  end
end

class OrbitalMap
  attr_accessor :planets

  def initialize(planets = {})
    @planets = planets
  end
end

orbital_map = OrbitalMap.new

file.each do |line|
  orbit_arr = line.split(')').map(&:strip)

  unless orbital_map.planets[orbit_arr[0]]
    parent_planet = Planet.new(orbit_arr[0])
  else
    parent_planet = orbital_map.planets[orbit_arr[0]]
  end
  
  unless orbital_map.planets[orbit_arr[1]]
    orbiting_planet = Planet.new(orbit_arr[1])
  else
    orbiting_planet = orbital_map.planets[orbit_arr[1]]
  end
  
  orbiting_planet.orbits = parent_planet  
  orbital_map.planets[orbit_arr[0]] = parent_planet
  orbital_map.planets[orbit_arr[1]] = orbiting_planet
end

def orbital_line(planet)
  results = []
  while planet.orbits
    results << planet.orbits
    planet = planet.orbits
  end
  results
end

# part-1
# value = orbital_map.planets.values.reduce(0) do |total, planet|
#   total + planet.count_orbits
# end

# puts value
# 145250

# part-2
you = orbital_map.planets['YOU']
santa = orbital_map.planets['SAN']

my_orbital_lines = orbital_line(you).map(&:name)
santa_orbital_lines = orbital_line(santa).map(&:name)
first_intersection =  (my_orbital_lines & santa_orbital_lines).first

my_orbital_xfer = my_orbital_lines.index(first_intersection)
to_santa_orbital_xfer = santa_orbital_lines.index(first_intersection)
puts my_orbital_xfer + to_santa_orbital_xfer
#274