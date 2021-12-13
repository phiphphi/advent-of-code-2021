# frozen_string_literal: true

require 'benchmark'
require 'set'

def main
  lines = File.readlines('input.txt', chomp: true)

  # Extract dot coordinates and folds to make.
  split = lines.find_index('')
  dots = lines[0...split].map do |pair|
    pair.split(',')
        .map(&:to_i)
  end
  folds = lines[split + 1..lines.length]
            .map { |fold| fold.delete_prefix 'fold along ' }

  # Get the set of dot coordinates.
  paper = draw_dots(dots)

  # Perform the folds for the dots.
  folds.each do |fold|
    fold = fold.split('=')
    paper = fold(paper, fold[0], fold[1])
  end

  # Put the dots in a human-readable form.
  paper = make_readable(paper)
  paper.each { |line| p line.join }
end

# Returns the transparent paper representing the dots.
def draw_dots(dots)
  paper = Set.new

  dots.each do |dot|
    paper << [dot[1], dot[0]]
  end

  paper
end

# Simulates a fold in our paper.
def fold(paper, direction, line)
  line = line.to_i
  new_paper = Set.new

  paper.each do |coord|
    x = coord[0]
    y = coord[1]
    case direction
    when 'y'
      if x < line
        new_paper << [x, y]
      elsif x > line
        new_paper << [line - (x - line), y]
      end
    when 'x'
      if y < line
        new_paper << [x, y]
      elsif y > line
        new_paper << [x, line - (y - line)]
      end
    else
      p 'Unrecognized direction.'
    end
  end

  new_paper
end

# Makes the paper readable by revealing the letters.
def make_readable(paper)
  paper = paper.to_a
  x_coords = paper.transpose[0]
  y_coords = paper.transpose[1]
  result = Array.new(x_coords.max + 1) { Array.new(y_coords.max + 1, ' ') }

  paper.each do |coord|
    x = coord[0]
    y = coord[1]
    result[x][y] = '#'
  end

  result
end

main
