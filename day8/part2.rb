# frozen_string_literal: true

def main
  input = File.readlines('input.txt', chomp: true)
              .map { |line| line.split(' | ') }
  p count(input)
end

def count(input)
  count = 0
  input.each do |line|
    patterns = line[0].split(' ')
    output = line[1].split(' ').map { |i| i.chars.sort }
    count += solve_line(patterns, output)
  end
  count
end

def solve_line(patterns, output)
  # Figure out 1, 4, 7, and 8 - the unique patterns.
  solved, unsolved = solve_known(patterns)

  # Deduce the rest.
  solved = solve_unknown(solved, unsolved)

  # Use our solutions to figure out the output.
  decode(solved, output)
end

def solve_known(patterns)
  solved = Array.new(10)
  unsolved = []

  patterns.each do |pattern|
    chars = pattern.chars.sort
    case chars.length
    when 2
      solved[1] = chars
    when 4
      solved[4] = chars
    when 3
      solved[7] = chars
    when 7
      solved[8] = chars
    else
      unsolved << chars
    end
  end

  [solved, unsolved]
end

def solve_unknown(solved, unsolved)
  # Deducible letters.
  cf = solved[1]
  bd = solved[4] - cf
  a = solved[7] - cf
  eg = solved[8] - cf - bd - a

  # Use deduced letters to figure out the rest.
  unsolved.each do |chars|
    leftover = chars - cf
    if chars.length == 5 # 2, 3, 5
      if leftover.length == 3 # 3
        solved[3] = chars
      else # 2, 5
        leftover -= eg
        if leftover.length == 2 # 2
          solved[2] = chars
        else # 5
          solved[5] = chars
        end
      end
    else # 0, 6, 9
      if leftover.length == 5 # 6
        solved[6] = chars
      else # 0, 9
        leftover -= eg
        if leftover.length == 2 # 0
          solved[0] = chars
        else
          solved[9] = chars
        end
      end
    end
  end

  solved
end

def decode(solved, output)
  result = 0
  output.each do |out|
    result *= 10
    result += solved.find_index(out)
  end

  result
end

main
