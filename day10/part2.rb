# frozen_string_literal: true

def main
  lines = File.readlines('input.txt', chomp: true)
              .map { |line| line.split('') }
  incomplete = lines.reject { |line| check_corrupt(line) }
  repairs = incomplete.map { |line| repair(line).reverse }
  scores = repairs.map { |repair| calc_score(repair) }

  p incomplete
  p repairs
  p scores
  p scores.sort[scores.length / 2]
end

def check_corrupt(line)
  stack = []

  line.each do |bracket|
    if %w|) ] } >|.include?(bracket)
      match = stack.pop
      next if check_match(match, bracket)

      return true
    else
      stack << bracket
    end
  end

  false
end

def check_match(first, second)
  ((first == '(') && (second == ')')) ||
    ((first == '[') && (second == ']')) ||
    ((first == '{') && (second == '}')) ||
    ((first == '<') && (second == '>'))
end

def repair(line)
  stack = []

  line.each do |bracket|
    if %w|) ] } >|.include?(bracket)
      match = stack.last
      stack.pop if check_match(match, bracket)
    else
      stack << bracket
    end
  end

  stack
end

def calc_score(repair)
  score = 0

  repair.each do |bracket|
    score *= 5
    case bracket
    when '('
      score += 1
    when '['
      score += 2
    when '{'
      score += 3
    when '<'
      score += 4
    else
      p 'Invalid bracket.'
    end
  end

  score
end

main
