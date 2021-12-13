# frozen_string_literal: true

def main
  lines = File.readlines('input.txt', chomp: true)

  split = lines.find_index('')
  dots = lines[0...split].map do |pair|
    pair.split(',')
        .map(&:to_i)
  end
  folds = lines[split + 1..lines.length]
            .map { |fold| fold.delete_prefix 'fold along ' }

  paper = draw_dots(dots)

  fold = folds[0].split('=')
  paper = fold(paper, fold[0], fold[1])

  p paper.flatten.count { |i| i > 0 }
end

# Returns the transparent paper representing the dots.
def draw_dots(dots)
  x_coords = dots.transpose[0]
  y_coords = dots.transpose[1]
  paper = Array.new(y_coords.max + 1) { Array.new(x_coords.max + 1, 0) }

  dots.each do |dot|
    x = dot[0]
    y = dot[1]
    paper[y][x] = 1
  end

  paper
end

# Simulates a fold in our paper.
def fold(paper, direction, line)
  line = line.to_i

  if direction == 'y'
    new_paper = Array.new(line) { Array.new(paper[0].length, 0) }
    paper.each_with_index do |row, x|
      row.each_with_index do |coord, y|
        if x < line
          new_paper[x][y] += coord
        elsif x > line
          new_paper[line - (x - line)][y] += coord
        end
      end
    end
  else
    new_paper = Array.new(paper.length) { Array.new(line, 0) }
    paper.each_with_index do |row, x|
      row.each_with_index do |coord, y|
        if y < line
          new_paper[x][y] += coord
        elsif y > line
          new_paper[x][line - (y - line)] += coord
        end
      end
    end
  end

  new_paper
end

main
