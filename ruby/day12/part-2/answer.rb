class Body
  attr_accessor :p, :v
  
  def initialize(x, y, z)
    @p = Struct.new(:x, :y, :z).new(x, y, z)
    @v = Struct.new(:x, :y, :z).new(0, 0, 0)
  end

  def energy
    @p.sum(&:abs) * @v.sum(&:abs)
  end
end

class System
  def initialize(bodies)
    @bodies = bodies
  end

  def tick
    # Calculate velocities
    @bodies.permutation(2).each do |(b1, b2)|
      b1.v.x += b2.p.x <=> b1.p.x
      b1.v.y += b2.p.y <=> b1.p.y
      b1.v.z += b2.p.z <=> b1.p.z
    end

    # Update positions
    @bodies.each do |b|
      b.p.x += b.v.x
      b.p.y += b.v.y
      b.p.z += b.v.z
    end
  end

  def positions_for(dimension)
    @bodies.map { |body| body.p[dimension] }
  end

  def energy
    @bodies.sum(&:energy)
  end
end

# Actual
moons = System.new([
  Body.new(-1, 0, 2),
  Body.new(2, -10, -7),
  Body.new(4, -8, 8),
  Body.new(3, 5, -1)
])

# PART 1
# 1000.times { moons.tick }
# puts moons.energy
# exit

# PART 2

puts "Lowest common multiple is.."

puts (0..2).map { |dimension|
  hs = {}
  t = 0

  10000000.times do |i|
    # Run a tick of the simulation
    moons.tick

    # Turn all the coordinates in a single dimension into a single number
    amt = moons.positions_for(dimension).pack("ssss")

    # No match? Keep a record for now
    if !hs[amt]
      hs[amt] = i
    elsif i - hs[amt] == 1
      # Is the match directly following an exact same set of coordinates?
      # If so, it's a point where the direction is inverting!      
      ord = t
      t = i - ord
      break t if ord > 0
    end
  end
}.reduce(1, :lcm) * 2