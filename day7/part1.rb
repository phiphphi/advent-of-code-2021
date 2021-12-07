# frozen_string_literal: true

def main
  crabs = File.read('input.txt').split(',').map(&:to_i)
  median = find_least_moves(crabs)
  moves = calc_moves(crabs, median)
  puts "Median: #{median}, fuel: #{moves}"
end

# Takes an array of crabs and finds the median.
def find_least_moves(crabs)
  arr = crabs.sort
  len = arr.length
  (arr[(len - 1) / 2] + arr[len / 2]) / 2
end

# Finds how many moves it will take to move all the crabs to the median position.
def calc_moves(crabs, median)
  sum = 0
  crabs.each { |crab| sum += (median - crab).abs }
  sum
end

main
