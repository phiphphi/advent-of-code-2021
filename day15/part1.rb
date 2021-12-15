# frozen_string_literal: true

require 'set'

def main
  map = File.readlines('input.txt', chomp: true)
              .map { |line| line.split('').map(&:to_i) }

  goal = [map.length - 1, map[0].length - 1]
  risk = search(map, [0, 0], goal)

  p risk
end

# A* search algorithm.
def search(map, start, goal)
  # Discovered nodes.
  open_set = Set[start]

  # Cost of current cheapest path from start to nodes.
  g_score = Hash.new(Float::INFINITY)
  g_score[start] = 0

  # gScore + heuristic score: current best guess for final path result.
  f_score = Hash.new(Float::INFINITY)
  f_score[start] = manhattan(start, goal)

  until open_set.empty?
    curr = open_set.min_by { |node| f_score[node] }
    return g_score[curr] if curr == goal

    open_set.delete(curr)
    neighbors(map, curr).each do |neighbor|
      tentative_risk = g_score[curr] + get_risk(map, neighbor)
      next unless tentative_risk < g_score[neighbor]

      # Path to neighbor is better than any previous path.
      g_score[neighbor] = tentative_risk
      f_score[neighbor] = tentative_risk + manhattan(neighbor, goal)
      open_set << neighbor unless open_set.include? neighbor
    end
  end

  # Failed to find a route.
  -1
end

# Manhattan distance formula.
def manhattan(start, goal)
  (start[0] - goal[0]).abs + (start[1] - goal[1]).abs
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
