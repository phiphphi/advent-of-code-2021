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

  folds.each do |fold|
    fold = fold.split('=')
    paper = fold(paper, fold[0], fold[1])
  end

  paper = make_readable(paper)
  paper.each { |line| p line.join }
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

# Makes the paper readable by revealing the letters.
def make_readable(paper)
  paper.each_with_index do |line, x|
    line.each_with_index do |val, y|
      if val > 0
        paper[x][y] = '#'
      else
        paper[x][y] = ' '
      end
    end
  end

  paper
end

main
