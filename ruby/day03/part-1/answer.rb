file = File.open("./input.txt")

wires = []
file.each do |wire_coords|
  wires << wire_coords.split(',')
end

# wires = ["R8,U5,L5,D3".split(","), "U7,R6,D4,L4".split(",")]

Coord = Struct.new(:x, :y)

class Wire
  NORTH = 'U'
  SOUTH = 'D'
  EAST = 'R'
  WEST = 'L'

  attr_reader :array_of_coords, :coords
  attr_accessor :current_pos

  def initialize(array_of_coords)
    @array_of_coords = array_of_coords
    @coords = []
    @current_pos = [0,0]
    process_the_coords
  end

  def process_the_coords
    array_of_coords.each do |direction|
      move, steps = parse_the_direction(direction)
      if move == NORTH
        affect_y_coords(steps)
      elsif move == SOUTH
        affect_y_coords(-1 * steps)
      elsif move == EAST
        affect_x_coords(steps)
      elsif move == WEST
        affect_x_coords(-1 * steps)
      end
    end
  end

  private

  def parse_the_direction(direction)
    move = direction[0]
    steps = direction[1..-1]
    [move, steps.to_i]
  end

  def affect_y_coords(value)
    if value > 0
      value.times do
        @current_pos = [@current_pos.first, @current_pos.last + 1]
        @coords << current_pos
      end
    else
      value.abs.times do
        @current_pos = [@current_pos.first, @current_pos.last - 1]
        @coords << current_pos
      end
    end
  end

  def affect_x_coords(value)
    if value > 0
      value.times do
        @current_pos = [@current_pos.first + 1, @current_pos.last]
        @coords << current_pos
      end
    else
      value.abs.times do
        @current_pos = [@current_pos.first - 1, @current_pos.last]
        @coords << current_pos
      end
    end
  end
end

# puts wires
points_array_1 = Wire.new(wires.first).coords
points_array_2 = Wire.new(wires.last).coords

crosses = points_array_1 & points_array_2
value = crosses.reduce(9999999) do |accum, ele|
  ele.first.abs + ele.last.abs < accum ? ele.first.abs + ele.last.abs : accum
end

p value

