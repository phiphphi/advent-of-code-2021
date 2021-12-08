# frozen_string_literal: true

def main
  input = File.readlines('input.txt', chomp: true)
              .map { |line| line.split(' | ') }
  p count(input)
end

def count(input)
  count = 0
  input.each do |line|
    patterns = line[1].split(' ')
    patterns.each do |pattern|
      count += 1 if pattern.length == 2 || pattern.length == 3 || pattern.length == 4 || pattern.length == 7
    end
  end
  count
end

main
