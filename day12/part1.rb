# frozen_string_literal: true

def main
  lines = File.readlines('input.txt', chomp: true)
              .map { |line| line.split('-') }

  map = build_map(lines)
  count = search(map, [], 'start')

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

# Finds the list of paths from start to finish that only visit small caves once.
def search(map, visited, cave)
  # Return our path if we made it to the end.
  return 1 if cave == 'end'

  paths = 0

  map[cave].each do |adj|
    # Invalid cave to revisit.
    next if (cave == cave.downcase) && (visited.include? cave)

    visited << cave
    paths += search(map, visited, adj)
    visited.pop
  end

  paths
end

main
