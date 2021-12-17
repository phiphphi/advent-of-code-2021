# frozen_string_literal: true

def main
  line = File.read('input.txt')
  target = get_target(line)

  coords = brute_force(target)
  p coords.length
end

def get_target(line)
  line = line.delete_prefix('target area: ')
  line = line.split(' ')
  line[0] = line[0].delete_prefix('x=').split('..').map(&:to_i)
  line[1] = line[1].delete_prefix('y=').split('..').map(&:to_i)
  [line[0], line[1]]
end

# Find all initial velocities that make it to the target area.
def brute_force(target)
  velocities = []
  x_min = get_which_triangular(target[0][0])
  y_max = get_which_triangular(get_triangular_num(target[1][0]))

  # Test "lower range" (all x values from 0 - lower x pos).
  (x_min...target[0][0]).each do |x|
    (target[1][0]..y_max).each do |y|
      velocities << [x, y] if check_bounds(target, x, y)
    end
  end

  # Get guaranteed "upper range" (all x and y values in target area).
  (target[0][0]..target[0][1]).each do |x|
    (target[1][0]..target[1][1]).each do |y|
      velocities << [x, y]
    end
  end

  velocities
end

def check_bounds(target, dx, dy)
  x_pos = 0
  y_pos = 0
  while x_pos < target[0][0] || y_pos > target[1][1]
    x_pos += dx
    y_pos += dy

    # Adjust velocities.
    if dx.negative?
      dx += 1
    elsif dx.positive?
      dx -= 1
    end
    dy -= 1

    # Overshot the target.
    return false if x_pos > target[0][1] || y_pos < target[1][0]
  end

  true
end

def get_triangular_num(num)
  num * (num + 1) / 2
end

def get_which_triangular(num)
  Integer.sqrt(num * 2).floor
end

main
