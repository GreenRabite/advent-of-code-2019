file = File.read("./input.txt")

intcode_list = file.split(',').map(&:to_i)

class IntcodeParser
  ADDITION = 1
  MULTIPLY = 2
  INSERT = 3
  OUTPUT = 4
  JUMP_TRUE = 5
  JUMP_FALSE = 6
  LESS_THAN = 7
  EQUALS = 8
  STOP = 99

  attr_accessor :intcode_list , :output, :stop, :input, :index
  
  def initialize(intcode_list, input, phase_setting)
    @intcode_list = intcode_list.dup
    @input = input
    @output = nil
    @index= 0
    @phase_setting = phase_setting
    @consume_phase_setting = false
    @stop = false
    @jump = nil
  end

  def handle_params(code, value)
    if code == 0
      @intcode_list[value]
    elsif code == 1
      value
    end
  end

  def used_phase_setting?
    @consume_phase_setting
  end

  def process_addition(params, slice)
    #params[0] == 0 -> @intcode[slice[0]]
    #params[0] == 1 -> slice[0]
    #params[1] == 0  -> @intcode[slice[1]]
    #params[1] == 1 -> slice[1]
    #params[2] == 0 -> @intcode[slice[2]]
    @intcode_list[slice[2]] = handle_params(params[0], slice[0]) + handle_params(params[1], slice[1])
  end

  def process_multiply(params, slice)
    @intcode_list[slice[2]] = handle_params(params[0], slice[0]) * handle_params(params[1], slice[1])
  end

  def process_insert(slice)
    if used_phase_setting?
      @intcode_list[slice] = @input
    else
      @intcode_list[slice] = @phase_setting
      @consume_phase_setting = true
    end
  end

  def process_output(params,slice)
    @output = handle_params(params[0], slice[0])
    # puts '----------------------------------------'
    # puts "OUTPUT CODE: #{handle_params(params[0], slice[0])}"
    # puts '----------------------------------------'
  end

  def process_jump_true(params, slice)
    if handle_params(params[0], slice[0]) != 0
      @jump = handle_params(params[1], slice[1])
      return 'jump'
    end
  end

  def process_jump_false(params, slice)
    if handle_params(params[0], slice[0]) == 0
      @jump = handle_params(params[1], slice[1])
      return 'jump'
    end
  end

  def process_less_than(params, slice)
    if handle_params(params[0], slice[0]) < handle_params(params[1], slice[1])
      @intcode_list[slice[2]] = 1
    else
      @intcode_list[slice[2]] = 0
    end
  end

  def process_equals(params, slice)
    if handle_params(params[0], slice[0]) == handle_params(params[1], slice[1])
      @intcode_list[slice[2]] = 1
    else
      @intcode_list[slice[2]] = 0
    end
  end
  
  def run_the_program(input = false)
    if input
      @input=input
    end
    while @index < @intcode_list.length
      size = additional_slice_size(@intcode_list[@index])
      a = parse_optcode(@intcode_list[@index..@index + size])
      if a == 'jump'
        @index = @jump
      elsif a == 'stop'
        # i = @intcode_list.length
        @stop = true
        return self
      elsif a == 'output'
        @index += size + 1
        return self
      else
        @index+= size + 1 
      end
    end
  end

  def parse_optcode(command)
    stringify_value = leading_zeroes(command.first)
    opt_code = stringify_value[-2..-1].to_i
    params = stringify_value[0...-2].split("").reverse.map(&:to_i)

    if opt_code == ADDITION
      process_addition(params, command[1..-1])
    elsif opt_code == MULTIPLY
      process_multiply(params, command[1..-1])
    elsif opt_code == OUTPUT
      process_output(params, command[1..-1])
      return 'output'
    elsif opt_code == INSERT
      process_insert(command.last)
    elsif opt_code == JUMP_TRUE
      process_jump_true(params, command[1..-1])
    elsif opt_code == JUMP_FALSE
      process_jump_false(params, command[1..-1])
    elsif opt_code == LESS_THAN
      process_less_than(params, command[1..-1])
    elsif opt_code == EQUALS
      process_equals(params, command[1..-1])
    elsif opt_code == STOP
      # puts 'STOP'
      return 'stop'
    end
  end

  def additional_slice_size(value) 
    stringify_value = leading_zeroes(value)
    opt_code = stringify_value[-2..-1].to_i
    # conditional tree
    if opt_code == ADDITION || opt_code == MULTIPLY || opt_code == LESS_THAN || opt_code == EQUALS
      3
    elsif opt_code == INSERT || opt_code == OUTPUT
      1
    elsif opt_code == JUMP_TRUE || opt_code == JUMP_FALSE
      2
    elsif opt_code == STOP
      0
    end
  end

  private

  def leading_zeroes(value)
    value.to_s.rjust(4, "0")
  end
end

#part-2
values = "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10".split(",").map(&:to_i)
# a = IntcodeParser.new(intcode_list, 0).run_the_program
codes = [5,6,7,8,9].permutation.to_a
max_thruster = 0
local_thruster = 0
parse_once = false
memory_address = {}

# loop do
#   unless parse_once
#     a = IntcodeParser.new(values, 0, 9).run_the_program
#     b = IntcodeParser.new(values, a.output, 7).run_the_program
#     c = IntcodeParser.new(values, b.output, 8).run_the_program
#     d = IntcodeParser.new(values, c.output, 5).run_the_program
#     e = IntcodeParser.new(values, d.output, 6).run_the_program
#   else
#     a = memory_address['new_a'].run_the_program(memory_address['new_e'].output)
#     b = memory_address['new_b'].run_the_program(memory_address['new_a'].output)
#     c = memory_address['new_c'].run_the_program(memory_address['new_b'].output)
#     d = memory_address['new_d'].run_the_program(memory_address['new_c'].output)
#     e = memory_address['new_e'].run_the_program(memory_address['new_d'].output)
#   end
#   memory_address['new_a'] = a
#   memory_address['new_b'] = b
#   memory_address['new_c'] = c
#   memory_address['new_d'] = d
#   memory_address['new_e'] = e
#   puts e.output
#   max_thruster = e.output
#   break if e.stop
#   parse_once = true
# end

# puts max_thruster


codes.each do |code|
  loop do
    unless parse_once
      a = IntcodeParser.new(intcode_list, 0, code[0]).run_the_program
      b = IntcodeParser.new(intcode_list, a.output, code[1]).run_the_program
      c = IntcodeParser.new(intcode_list, b.output, code[2]).run_the_program
      d = IntcodeParser.new(intcode_list, c.output, code[3]).run_the_program
      e = IntcodeParser.new(intcode_list, d.output, code[4]).run_the_program
    else
      a = memory_address['new_a'].run_the_program(memory_address['new_e'].output)
      b = memory_address['new_b'].run_the_program(memory_address['new_a'].output)
      c = memory_address['new_c'].run_the_program(memory_address['new_b'].output)
      d = memory_address['new_d'].run_the_program(memory_address['new_c'].output)
      e = memory_address['new_e'].run_the_program(memory_address['new_d'].output)
    end
    
    memory_address['new_a'] = a
    memory_address['new_b'] = b
    memory_address['new_c'] = c
    memory_address['new_d'] = d
    memory_address['new_e'] = e
    local_thruster = memory_address['new_e'].output
    break if memory_address['new_e'].stop
    parse_once = true
  end
  
  if local_thruster > max_thruster
    max_thruster = local_thruster
  end
  parse_once = false
  local_thruster = 0
end


puts max_thruster
