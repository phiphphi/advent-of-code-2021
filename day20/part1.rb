# frozen_string_literal: true

def main(enhance)
  lines = File.readlines('input.txt', chomp: true)

  algorithm, image = split(lines)

  enhance.times do |x|
    flip = algorithm[0] == '#' ? x.odd? : false
    image = process(algorithm, image, flip)
  end

  p image.flatten.count('#')
  image.each { |l| p l.join('') }
end

# Split our input into the image enhancement algorithm and input image.
def split(lines)
  empty = lines.find_index('')
  algorithm = lines[0...empty].join('')
  image = lines[empty + 1..lines.length].map { |l| l.split('') }

  [algorithm, image]
end

# Perform a pass of the image enhancement algorithm.
def process(algorithm, image, flip)
  image = increase_size(image, flip)
  new_image = Array.new(image.length) { Array.new(image[0].length) }

  (0...image.length).each do |x|
    (0...image[0].length).each do |y|
      new_image[x][y] = get_pixel(algorithm, image, x, y, flip)
    end
  end

  new_image
end

# Adds a new band of dark pixels around the image.
def increase_size(image, flip)
  c = flip ? '#' : '.'
  image.each do |row|
    row.prepend(c)
    row << c
  end
  image.prepend(c * (image.length + 2))
  image << c * (image.length + 2)
  image
end

# Calculates the pixel to return from the input image.
def get_pixel(algorithm, image, x, y, flip)
  binary = []

  (x - 1..x + 1).each do |i|
    (y - 1..y + 1).each do |j|
      if i.negative? || i >= image.length || j.negative? || j > image[0].length
        # Index accesses outside the array are all dots or pound signs based on the iteration.
        val = flip ? '1' : '0'
        binary << val
      else
        val = image[i][j] == '#' ? '1' : '0'
        binary << val
      end
    end
  end

  # Convert our binary array to a decimal and find the corresponding pixel.
  algorithm[binary.join('').to_i(2)]
end

main(2)
