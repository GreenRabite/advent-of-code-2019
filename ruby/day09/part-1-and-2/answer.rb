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
  RELATIVE_BASE_ADJUST = 9
  STOP = 99

  attr_accessor :intcode_list , :output
  
  def initialize(intcode_list, input =0)
    @intcode_list = intcode_list + Array.new(100000,0)
    @input = input
    @output = nil
    @jump = nil
    @relative_base = 0
  end

  def handle_params(code, value)
    if code == 0
      @intcode_list[value]
    elsif code == 1
      value
    elsif code == 2
      @intcode_list[@relative_base + value]
    end
  end

  def handle_100ths_param(code,value)
    if code == 0
      value
    elsif code == 2
      @relative_base + value
    end
  end

  def process_addition(params, slice)
    #params[0] == 0 -> @intcode[slice[0]]
    #params[0] == 1 -> slice[0]
    #params[1] == 0  -> @intcode[slice[1]]
    #params[1] == 1 -> slice[1]
    #params[2] == 0 -> @intcode[slice[2]]
    @intcode_list[handle_100ths_param(params[2], slice[2])] = handle_params(params[0], slice[0]) + handle_params(params[1], slice[1])
  end

  def process_multiply(params, slice)
    @intcode_list[handle_100ths_param(params[2],slice[2])] = handle_params(params[0], slice[0]) * handle_params(params[1], slice[1])
  end

  def process_insert(params, slice)
    # @intcode_list[slice[0]] = @input
    if params[0] == 0
      @intcode_list[slice[0]] = @input
    elsif params[0] == 2
      @intcode_list[@relative_base + slice[0]] = @input
    end
  end

  def process_output(params,slice)
    @output = handle_params(params[0], slice[0])
    puts '----------------------------------------'
    puts "OUTPUT CODE: #{handle_params(params[0], slice[0])}"
    puts '----------------------------------------'
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
      @intcode_list[handle_100ths_param(params[2],slice[2])] = 1
    else
      @intcode_list[handle_100ths_param(params[2],slice[2])] = 0
    end
  end

  def process_equals(params, slice)
    if handle_params(params[0], slice[0]) == handle_params(params[1], slice[1])
      @intcode_list[handle_100ths_param(params[2],slice[2])] = 1
    else
      @intcode_list[handle_100ths_param(params[2],slice[2])] = 0
    end
  end

  def process_relative_base_adjust(params, slice)
    @relative_base += handle_params(params[0], slice[0])
  end
  
  def run_the_program
    i=0
    while i < @intcode_list.length
      size = additional_slice_size(@intcode_list[i])
      a = parse_optcode(@intcode_list[i..i + size])
      if a == 'jump'
        i = @jump
      elsif a == 'stop'
        i = @intcode_list.length + 1
      else
        i+= size + 1 
      end
    end
    return @output
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
    elsif opt_code == INSERT
      process_insert(params, command[1..-1])
    elsif opt_code == JUMP_TRUE
      process_jump_true(params, command[1..-1])
    elsif opt_code == JUMP_FALSE
      process_jump_false(params, command[1..-1])
    elsif opt_code == LESS_THAN
      process_less_than(params, command[1..-1])
    elsif opt_code == EQUALS
      process_equals(params, command[1..-1])
    elsif opt_code == RELATIVE_BASE_ADJUST
      process_relative_base_adjust(params, command[1..-1])
    elsif opt_code == STOP
      puts 'STOP'
      return 'stop'
    end
  end

  def additional_slice_size(value) 
    stringify_value = leading_zeroes(value)
    opt_code = stringify_value[-2..-1].to_i
    # conditional tree
    if opt_code == ADDITION || opt_code == MULTIPLY || opt_code == LESS_THAN || opt_code == EQUALS
      3
    elsif opt_code == INSERT || opt_code == OUTPUT || opt_code == RELATIVE_BASE_ADJUST
      1
    elsif opt_code == JUMP_TRUE || opt_code == JUMP_FALSE
      2
    elsif opt_code == STOP
      0
    end
  end

  private

  def leading_zeroes(value)
    value.to_s.rjust(5, "0")
  end
end

code = "104,1125899906842624,99".split(",").map(&:to_i)

# part-1
# a = IntcodeParser.new(intcode_list, 1).run_the_program
# ----------------------------------------
# OUTPUT CODE: 3546494377
# ----------------------------------------

# part-2
a = IntcodeParser.new(intcode_list, 2).run_the_program
# 47253