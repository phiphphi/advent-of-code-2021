# frozen_string_literal: true

def main
  crabs = File.read('input.txt').split(',').map(&:to_i)
  mean = find_least_moves(crabs)
  mean = [mean.ceil, mean.floor].min # Try both positions to account for error.
  moves = calc_moves(crabs, mean)
  puts "Mean: #{mean}, fuel: #{moves}"
end

# Takes an array of crabs and finds the mean.
def find_least_moves(crabs)
  crabs.sum(0.0) / crabs.length
end

# Finds how many moves it will take to move all the crabs to the mean position.
def calc_moves(crabs, mean)
  sum = 0
  crabs.each { |crab| sum += triangle((mean - crab).abs) }
  sum
end

# Calculate the triangular number for a distance.
def triangle(num)
  (num * (num + 1)) / 2
end

main
