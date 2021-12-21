# frozen_string_literal: true

def main
  lines = File.readlines('input.txt', chomp: true)
              .map { |line| line.split('') }

  result = add(lines)
  p result.join('')

  magnitude, = magnitude(result)
  p magnitude
end

def add(lines)
  result = lines[0]

  lines.drop(1).each do |line|
    result.prepend('[').append(',').append(*line).append(']')
    result = process(result)
  end

  result
end

def process(line)
  # Loop until we can't explode or split the pairs anymore.
  looping = true
  while looping
    line, exploded = check_explode(line)
    line, split = check_split(line)
    break if !exploded && !split
  end
  
  line
end

# Return true if exploded, false otherwise.
def check_explode(line)
  i = 0
  depth = 0
  exploded = false

  while i < line.length
    c = line[i]
    case c
    when '['
      depth += 1
      if depth == 5
        # Go left, then go right.
        # Then replace the pair with 0.
        left = line[i + 1].to_i
        right = line[i + 3].to_i
        line = add_left(line, i - 2, left)
        line = add_right(line, i + 6, right)
        line[i..i + 4] = '0'
        depth -= 1
        exploded = true
      end
    when ']'
      depth -= 1
    else
      # Continue, ignoring commas and numbers.
    end
    i += 1
  end

  [line, exploded]
end

# Add the left pair number to the closest left number (if it exists).
def add_left(line, i, left)
  while i >= 0
    if is_int(line[i])
      line[i] = (line[i].to_i + left).to_s
      return line
    end
    i -= 1
  end

  line
end

# Add the right pair number to the closest right number (if it exists).
def add_right(line, i, right)
  while i < line.length
    if is_int(line[i])
      line[i] = (line[i].to_i + right).to_s
      return line
    end
    i += 1
  end

  line
end

def is_int(str)
  str.to_i.to_s == str
end

# Returns true if split, false otherwise. Returns on first split to check for explodes.
def check_split(line)
  i = 0

  while i < line.length
    c = line[i]
    if is_int(c) && c.to_i >= 10
      # Replace the value with a split pair.
      left = (c.to_i / 2.0).floor.to_s
      right = (c.to_i / 2.0).ceil.to_s
      line[i, 1] = ['[', left, ',', right, ']']
      return [line, true]
    end
    i += 1
  end

  [line, false]
end

# Calculate the magnitude of a shellfish number.
def magnitude(line)
  c = line[0]
  if c == '['
    left, leftover = magnitude(line.drop(1)) # Skip front bracket.
    right, leftover = magnitude(leftover.drop(1)) # Skip comma.
    [3 * left + 2 * right, leftover.drop(1)] # Return magnitude, skipping end bracket.
  elsif is_int(c)
    [c.to_i, line.drop(1)]
  end
end

main
