file = File.read("../part-1/input.txt")

# image is 25px x 6

sif = file.split('').map(&:to_i)
layers = []
sif.each_slice(150) do |row|
  layers << row
end

image = Array.new(6) {Array.new(25, 2)}

mapping = {
  0 => '▒',
  1 =>  '█'
}

layers.each do |layer|
  layer.each_with_index do |pixel, idx|
    row = idx / 25
    column = idx % 25
    if pixel == 0 || pixel == 1
      if image[row][column] == 2
        image[row][column] = mapping[pixel]
      end
    end
  end
end

p image

# [█, -, -, █, -, -, █, █, -, -, █, █, █, -, -, -, █, █, -, -, █, █, █, █, -],
# [█, -, -, █, -, █, -, -, █, -, █, -, -, █, -, █, -, -, █, -, █, -, -, -, -],
# [█, █, █, █, -, █, -, -, -, -, █, █, █, -, -, █, -, -, -, -, █, █, █, -, -],
# [█, -, -, █, -, █, -, █, █, -, █, -, -, █, -, █, -, -, -, -, █, -, -, -, -],
# [█, -, -, █, -, █, -, -, █, -, █, -, -, █, -, █, -, -, █, -, █, -, -, -, -],
# [█, -, -, █, -, -, █, █, █, -, █, █, █, -, -, -, █, █, -, -, █, -, -, -, -]
