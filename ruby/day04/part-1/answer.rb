# input from  372304-847060

class Digit
  def initialize(digits)
    @digits = digits.to_s.split("").map(&:to_i)
  end

  def valid?
    double? && increasing? && single_pair?
  end

  def double?
    @digits[0] == @digits[1] || 
    @digits[1] == @digits[2] || 
    @digits[2] == @digits[3] || 
    @digits[3] == @digits[4] || 
    @digits[4] == @digits[5]
  end

  def increasing?
    @digits[0] <= @digits[1] &&
    @digits[1] <= @digits[2] &&
    @digits[2] <= @digits[3] &&
    @digits[3] <= @digits[4] &&
    @digits[4] <= @digits[5]
  end

  def single_pair?
    hash = @digits.each_with_object(Hash.new(0)) do |digit,hash|
      hash[digit]+=1
    end
    return true if hash.values.include?(2)
  end
end

count=0
(372304..847060).each do |num|
  count +=1 if Digit.new(num).valid?
end

# part-1
# puts count
# 475

# part-2
puts count
# 297

