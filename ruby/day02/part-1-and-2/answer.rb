file = File.read("./input.txt")

intcode_list = file.split(',').map(&:to_i)

class IntcodeParser
  ADDITION = 1
  MULTIPLY = 2
  STOP = 99

  attr_accessor :intcode_list 
  
  def initialize(intcode_list)
    @intcode_list = intcode_list
  end
   
  def process_code(*args)
    if args.first == ADDITION
      @intcode_list[args.last] = @intcode_list[args[1]] + @intcode_list[args[2]]
    elsif args.first == MULTIPLY
      @intcode_list[args.last] = @intcode_list[args[1]] * @intcode_list[args[2]]
    end
  end
  
  def run_the_program
    @intcode_list.each_slice(4) do |slice|
      return @intcode_list[0] if slice.first == STOP
      process_code(*slice)
    end
  end
end

# part 1 - 3267740
# new_list = intcode_list.dup
# new_list[1] = 12
# new_list[2] = 2
# p IntcodeParser.new(new_list).run_the_program


# part 2
def find_this_value(value, intcode_list)
  (0..99).each do |noun|
    (0..99).each do |verb|
      new_list = intcode_list.dup
      new_list[1] = noun
      new_list[2] = verb
      return 100 * noun + verb if IntcodeParser.new(new_list).run_the_program == value
    end
  end
end

puts find_this_value(19690720, intcode_list)


