# frozen_string_literal: true

require 'set'
require 'algorithms'

def main
  map = File.readlines('input.txt', chomp: true)
            .map { |line| line.split('').map(&:to_i) }
  map = expand_map(map, 5)

  goal = [map.length - 1, map[0].length - 1]

  risk = search(map, [0, 0], goal)
  p risk
end

# Copies the map, increasing tiles by 1 until they roll over 9 back to 1.
def expand_map(map, factor)
  new_map = Array.new(map.length * factor) { Array.new(map[0].length * factor) }

  # Copy in new tiles.
  factor.times do |i|
    y_shift = i * map.length
    factor.times do |j|
      x_shift = j * map[0].length
      (0...map.length).each do |y|
        (0...map[0].length).each do |x|
          new_val = map[y][x] + i + j
          new_map[y + y_shift][x + x_shift] = new_val > 9 ? new_val % 9 : new_val
        end
      end
    end
  end

  new_map
end

# Dijkstra's search algorithm.
def search(map, start, goal)
  # Discovered nodes.
  open_set = Containers::MinHeap.new
  open_set.push(start, 0)

  # Cost of current cheapest path from start to nodes.
  g_score = Hash.new(Float::INFINITY)
  g_score[start] = 0

  until open_set.empty?
    curr = open_set.next_key
    return g_score[curr] if curr == goal

    open_set.delete(curr)
    neighbors(map, curr).each do |neighbor|
      tentative_risk = g_score[curr] + get_risk(map, neighbor)
      next unless tentative_risk < g_score[neighbor]

      # Path to neighbor is better than any previous path.
      g_score[neighbor] = tentative_risk
      open_set.push(neighbor, tentative_risk) unless open_set.has_key?(neighbor)
    end
  end

  # Failed to find a route.
  -1
end

# Get neighbors for node.
def neighbors(map, node)
  neighbors = []
  y = node[0]
  x = node[1]

  neighbors << [y - 1, x] if y.positive?
  neighbors << [y + 1, x] if y < map.length - 1
  neighbors << [y, x - 1] if x.positive?
  neighbors << [y, x + 1] if x < map[0].length - 1

  neighbors
end

# Look up node risk.
def get_risk(map, node)
  map[node[0]][node[1]]
end

main
