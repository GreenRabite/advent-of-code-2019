Moon = Struct.new(:pos, :vel) do
  def potential_energy
    pos.x.abs + pos.y.abs + pos.z.abs
  end

  def kinetic_energy
    vel.x.abs + vel.y.abs + vel.z.abs
  end

  def digit_map
    "#{pos.x}#{pos.y}#{pos.z}#{vel.x}#{vel.y}#{vel.z}"
  end

  def velocity_zero_out
    vel.x == 0 && vel.y ==0 && vel.z == 0 
  end
end

Position = Struct.new(:x, :y, :z)
Velocity = Struct.new(:x, :y, :z)

moons = []
map = {"0" => {}, "1" => {}, "2" => {}, "3" => {}}
truth_table = {"0" => false, "1" => false, "2" => false, "3" => false}
initial_table = {"0" => "-102000", "1" => "2-10-7000", "2" => "4-88000", "3" => "35-1000"}

file = File.open("./input.txt")
file.each do |line|
  x = line.match(/[x]=((|-)\d+)/).captures.first.to_i
  y = line.match(/[y]=((|-)\d+)/).captures.first.to_i
  z = line.match(/[z]=((|-)\d+)/).captures.first.to_i
  moons << Moon.new(Position.new(x, y, z), Velocity.new(0, 0, 0))
end

# moons << Moon.new(Position.new(-1,0,2), Velocity.new(0,0,0))
# moons << Moon.new(Position.new(2,-10,-7), Velocity.new(0,0,0))
# moons << Moon.new(Position.new(4,-8,8), Velocity.new(0,0,0))
# moons << Moon.new(Position.new(3,5,-1), Velocity.new(0,0,0))



def process_gravity(moon, other_moon)
  if moon.pos.x < other_moon.pos.x
    moon.vel.x += 1
    # other_moon.vel.x -= 1
  elsif moon.pos.x > other_moon.pos.x
    moon.vel.x -= 1
    # other_moon.vel.x += 1
  end

  if moon.pos.y < other_moon.pos.y
    moon.vel.y += 1
    # other_moon.vel.y -= 1
  elsif moon.pos.y > other_moon.pos.y
    moon.vel.y -= 1
    # other_moon.vel.y += 1
  end

  if moon.pos.z < other_moon.pos.z
    moon.vel.z += 1
    # other_moon.vel.z -= 1
  elsif moon.pos.z > other_moon.pos.z
    moon.vel.z -= 1
    # other_moon.vel.z += 1
  end
end

def process_velocity(moon)
  moon.pos.x += moon.vel.x
  moon.pos.y += moon.vel.y
  moon.pos.z += moon.vel.z
end

counter = 0
# while counter != 1000
loop do
  # fix gravity first
  moons.each do |moon|
    (moons-[moon]).each do |other_moon|
      process_gravity(moon, other_moon)
    end
  end

  #then apply velocity
  moons.each do |moon|
    process_velocity(moon)
  end

  # if map["3"][moons[3].digit_map]
  #   truth_table["3"] = true
  # end
  # map["3"][moons[3].digit_map] = true
  if counter != 0
    moons.each_with_index do |moon, idx|
      if moon.velocity_zero_out
        truth_table["#{idx}"] = true
        puts "Moon #{idx} is #{moon} and counter is #{counter}"
        # puts "#{(counter + 1) * 2}"
      end

      # map["#{idx}"][moon.velocity_zero_out] = true
    end
  end
  # if counter != 0
  #   moons.each_with_index do |moon, idx|
  #     if moon.digit_map == initial_table["#{idx}"]
  #       truth_table["#{idx}"] = true
  #       puts "Moon #{idx} is #{moon} and counter is #{counter}" 
  #     end
  #   end
  # end


  counter +=1
  # break if truth_table["0"] && truth_table["1"] && truth_table["2"] && truth_table["3"]
end

# energy = 0
# total_energy = moons.reduce(0) do |accum,moon|
#   accum + moon.potential_energy * moon.kinetic_energy
# end

# part-1
# puts total_energy
# 6849

# part-2
# Moon A first one at 2686963
# Moon B first one at 6066287
# Moon C first one at 3766971
# Moon D first one at 10670721
# 6.5519516067493E+26
# 2686963,6066287, 3766971,10670721
# Moon 0 is #<struct Moon pos=#<struct Position x=145, y=-2, z=142>, vel=#<struct Velocity x=-2, y=-7, z=16>> and counter is 2686963
# Moon 2 is #<struct Moon pos=#<struct Position x=-78, y=3, z=7>, vel=#<struct Velocity x=-2, y=0, z=1>> and counter is 3766971
# Moon 2 is #<struct Moon pos=#<struct Position x=-99, y=-36, z=-24>, vel=#<struct Velocity x=5, y=13, z=-44>> and counter is 5082061
# Moon 1 is #<struct Moon pos=#<struct Position x=406, y=-72, z=-210>, vel=#<struct Velocity x=-8, y=5, z=11>> and counter is 6066287
# Moon 1 is #<struct Moon pos=#<struct Position x=397, y=-66, z=-198>, vel=#<struct Velocity x=-9, y=6, z=12>> and counter is 6066288
# Moon 1 is #<struct Moon pos=#<struct Position x=387, y=-59, z=-185>, vel=#<struct Velocity x=-10, y=7, z=13>> and counter is 6066289
# Moon 1 is #<struct Moon pos=#<struct Position x=376, y=-51, z=-171>, vel=#<struct Velocity x=-11, y=8, z=14>> and counter is 6066290
# Moon 1 is #<struct Moon pos=#<struct Position x=364, y=-42, z=-156>, vel=#<struct Velocity x=-12, y=9, z=15>> and counter is 6066291
# Moon 1 is #<struct Moon pos=#<struct Position x=351, y=-32, z=-140>, vel=#<struct Velocity x=-13, y=10, z=16>> and counter is 6066292
# Moon 1 is #<struct Moon pos=#<struct Position x=337, y=-21, z=-123>, vel=#<struct Velocity x=-14, y=11, z=17>> and counter is 6066293
# Moon 2 is #<struct Moon pos=#<struct Position x=-233, y=66, z=-88>, vel=#<struct Velocity x=-4, y=1, z=-40>> and counter is 7572504
# Moon 1 is #<struct Moon pos=#<struct Position x=77, y=8, z=72>, vel=#<struct Velocity x=22, y=8, z=11>> and counter is 8391397
# Moon 1 is #<struct Moon pos=#<struct Position x=-381, y=-62, z=180>, vel=#<struct Velocity x=-15, y=5, z=26>> and counter is 8537258
# Moon 0 is #<struct Moon pos=#<struct Position x=-78, y=-13, z=-474>, vel=#<struct Velocity x=7, y=-10, z=-4>> and counter is 8851068
# Moon 1 is #<struct Moon pos=#<struct Position x=112, y=4, z=769>, vel=#<struct Velocity x=-15, y=-8, z=-41>> and counter is 9412487
# Moon 3 is #<struct Moon pos=#<struct Position x=-255, y=2, z=22>, vel=#<struct Velocity x=30, y=-2, z=18>> and counter is 10670721

# aluo@winterfell-citadel part-1|master⚡ ⇒ ruby answer.rb
# Moon 2 is #<struct Moon pos=#<struct Position x=-96, y=-11, z=40>, vel=#<struct Velocity x=0, y=0, z=0>> and counter is 24552
# Moon 3 is #<struct Moon pos=#<struct Position x=-218, y=-3, z=206>, vel=#<struct Velocity x=0, y=0, z=0>> and counter is 35659
# Moon 1 is #<struct Moon pos=#<struct Position x=501, y=-73, z=73>, vel=#<struct Velocity x=0, y=0, z=0>> and counter is 37278
# Moon 0 is #<struct Moon pos=#<struct Position x=926, y=-1, z=-329>, vel=#<struct Velocity x=0, y=0, z=0>> and counter is 158718
puts counter
