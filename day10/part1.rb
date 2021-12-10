# frozen_string_literal: true

def main
  lines = File.readlines('input.txt', chomp: true)
              .map { |line| line.split('') }
  score = find_corrupted(lines)
  p score
end

def find_corrupted(lines)
  score = 0
  stack = []
  
  lines.each do |line|
    line.each do |bracket|
      if %w|) ] } >|.include?(bracket)
        match = stack.pop
        if check_match(match, bracket)
          next
        else
          p "Expected #{match}, but found #{bracket} instead."
          score += add_points(bracket)
          stack = []
          break
        end
      else
        stack << bracket
      end
    end
  end

  score
end

def check_match(first, second)
  ((first == '(') && (second == ')')) ||
    ((first == '[') && (second == ']')) ||
    ((first == '{') && (second == '}')) ||
    ((first == '<') && (second == '>'))
end

def add_points(illegal)
  case illegal
  when ')'
    3
  when ']'
    57
  when '}'
    1197
  when '>'
    25_137
  else
    0
  end
end

main
