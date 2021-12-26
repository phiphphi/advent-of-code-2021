# frozen_string_literal: true

def main
  lines = File.readlines('input.txt', chomp: true)

  map = initialize_map(lines)
  steps = move(map)
  p steps
end

# Create the map of sea cucumbers in a 2D int array.
def initialize_map(lines)
  map = []

  lines.each do |line|
    map_row = []
    line.chars.each do |c|
      case c
      when '>'
        map_row << 1
      when 'v'
        map_row << 2
      else
        map_row << 0
      end
    end
    map << map_row
  end

  map
end

# Find the step when the sea cucumbers stop moving.
def move(map)
  prev_map = []
  steps = 0

  while true
    break if prev_map == map.flatten
    prev_map = map.flatten

    map = move_right(map)
    map = move_down(map)

    steps += 1
  end

  steps
end

def move_right(map)
  move = {}

  map.each_with_index do |row, x|
    row.each_with_index do |num, y|
      y_pos = (y + 1) % map[x].length
      if num == 1 && map[x][y_pos] == 0
        move[[x, y]] = [x, y_pos]
      end
    end
  end

  move.each do |coords|
    map[coords[0][0]][coords[0][1]] = 0
    map[coords[1][0]][coords[1][1]] = 1
  end

  map
end

def move_down(map)
  move = {}

  map.each_with_index do |row, x|
    row.each_with_index do |num, y|
      x_pos = (x + 1) % map.length
      if num == 2 && map[x_pos][y] == 0
        move[[x, y]] = [x_pos, y]
      end
    end
  end

  move.each do |coords|
    map[coords[0][0]][coords[0][1]] = 0
    map[coords[1][0]][coords[1][1]] = 2
  end

  map
end

main
