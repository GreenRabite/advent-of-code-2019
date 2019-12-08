file = File.read("./input.txt")

# image is 25px x 6

sif = file.split('').map(&:to_i)
results = []
sif.each_slice(150) do |row|
  results << row
end

min=nil
noncorrupted_set = nil

results.each do |result|
  if min.nil?
    noncorrupted_set = result
    min = result.count(0)
  end
  if result.count(0) < min
    noncorrupted_set = result
    min = result.count(0)
  end
end

# part-1
puts noncorrupted_set.count(1) * noncorrupted_set.count(2)
#2904

