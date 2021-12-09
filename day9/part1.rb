# frozen_string_literal: true

def main
  map = File.readlines('input.txt', chomp: true)
            .map do |row|
    row.split('')
       .map(&:to_i)
  end

  low_points = find_low_points(map)

  p low_points
  p low_points.map { |p| p + 1 }.sum
end

def find_low_points(map)
  points = []
  map.each_with_index do |row, x|
    row.each_with_index do |point, y|
      points << point if check_low(map, point, x, y)
    end
  end

  points
end

def check_low(map, point, x, y)
  adj = []
  
  adj << map[x - 1][y] if x != 0
  adj << map[x + 1][y] if x != map.length - 1
  adj << map[x][y - 1] if y != 0
  adj << map[x][y + 1] if y != map[0].length - 1

  adj.all? { |adj_point| adj_point > point }
end

main
