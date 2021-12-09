# frozen_string_literal: true

require 'set'

def main
  map = File.readlines('input.txt', chomp: true)
            .map do |row|
    row.split('')
       .map(&:to_i)
  end

  low_points = find_low_points(map)
  basin_sizes = find_basins(map, low_points)

  p low_points
  p basin_sizes
  p basin_sizes.sort.last(3).reduce(1, :*) # Get product of top 3 values.
end

def find_low_points(map)
  points = []
  map.each_with_index do |row, x|
    row.each_with_index do |point, y|
      points << [x, y] if check_low(map, point, x, y)
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

def find_basins(map, low_points)
  basin_sizes = []
  
  low_points.each do |low|
    basin_sizes << calc_basin_size(map, low, Set.new)
  end

  basin_sizes
end

def calc_basin_size(map, low, visited)
  x = low[0]
  y = low[1]
  return 0 if x.negative? || x >= map.length ||
              y.negative? || y >= map[0].length ||
              visited.include?(low) || map[x][y] == 9

  visited << low

  1 + calc_basin_size(map, [x - 1, y], visited) +
    calc_basin_size(map, [x + 1, y], visited) +
    calc_basin_size(map, [x, y - 1], visited) +
    calc_basin_size(map, [x, y + 1], visited)
end

main
