# frozen_string_literal: true

def main
  lines = File.readlines('input.txt', chomp: true)
              .map { |line| line.split('-') }

  map = build_map(lines)
  count = search(map, [], 'start', true)

  p count
end

# Creates a hash of map caves to adjacent caves.
def build_map(lines)
  map = Hash.new { |h, k| h[k] = [] }

  lines.each do |line|
    key = line[0]
    val = line[1]
    # Create a two-way mapping between caves.
    map[key] << val
    map[val] << key
  end

  map
end

# Finds the list of paths from start to finish that can visit a single small
# cave twice.
def search(map, visited, cave, visit_twice)
  # Return our path if we made it to the end.
  return 1 if cave == 'end'

  paths = 0

  map[cave].each do |adj|
    visited << cave

    if adj == adj.downcase
      if !visited.include? adj # First visit to small cave.
        paths += search(map, visited, adj, visit_twice)
      elsif visit_twice && !%w[start end].include?(adj) # Second visit allowed.
        paths += search(map, visited, adj, false)
      end
    else
      paths += search(map, visited, adj, visit_twice)
    end

    visited.pop
  end

  paths
end

main
