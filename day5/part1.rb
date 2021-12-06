# frozen_string_literal: true

def main
  n = 1000
  lines = process_input
  map = Array.new(n) { Array.new(n, 0) }

  lines.each do |line|
    update_map(map, line)
  end

  # Get count where at least two lines overlap.
  print map.flatten.select { |x| x >= 2 }.count
end

# Process input into an array of pairs of vent coordinates.
def process_input
  lines = File.readlines('input.txt', chomp: true)

  pairs = lines.map { |line| line.split(' -> ') }
  pairs.each do |pair|
    pair[0] = pair[0].split(',').map(&:to_i)
    pair[1] = pair[1].split(',').map(&:to_i)
  end

  pairs
end

# Checks for a horizontal or vertical line and adds it to the map if it exists.
def update_map(map, line)
  first = line[0]
  second = line[1]
  if first[0] == second[0]
    draw_vertical(map, first, second)
  elsif first[1] == second[1]
    draw_horizontal(map, first, second)
  end
end

def draw_vertical(map, first, second)
  range = [first[1], second[1]].sort
  (range[0]..range[1]).each { |x| map[x][first[0]] += 1 }
end

def draw_horizontal(map, first, second)
  range = [first[0], second[0]].sort
  (range[0]..range[1]).each { |x| map[first[1]][x] += 1 }
end

main
