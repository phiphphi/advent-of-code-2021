# frozen_string_literal: true

@flashes = 0

def main(steps)
  lines = File.readlines('input.txt', chomp: true)
              .map { |line| line.split('').map(&:to_i) }

  # Perform the given number of steps for the octopuses.
  steps.times { lines = step(lines) }

  lines.each { |line| puts line.join() }

  puts @flashes
end

# Simulates one tick for all octopuses.
def step(lines)
  # First, increment all energy levels by 1.
  lines.each do |line|
    line.each_with_index do |_, y|
      line[y] += 1
    end
  end

  # Then, check for octopus flashes.
  lines.each_with_index do |line, x|
    line.each_with_index do |octopus, y|
      if octopus > 9
        lines = flash(lines, x, y)
      end
    end
  end

  lines
end

# Flash all adjacent octopuses.
def flash(lines, x, y)
  @flashes += 1
  lines[x][y] = 0

  x_start = [x - 1, 0].max
  x_end = [x + 1, lines.length - 1].min
  y_start = [y - 1, 0].max
  y_end = [y + 1, lines[0].length - 1].min

  (x_start..x_end).each do |i|
    (y_start..y_end).each do |j|
      # Increment unflashed octopuses.
      lines[i][j] += 1 unless lines[i][j] == 0

      if lines[i][j] > 9
        lines = flash(lines, i, j)
      end
    end
  end

  lines
end

main(100)
