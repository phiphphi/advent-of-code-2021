# frozen_string_literal: true

require 'benchmark'

RESET_FISH = 6
NEW_FISH = 8

def main(days)
  fish = File.read('input.txt').split(',').map(&:to_i)
  timers = Array.new(9, 0)

  # Convert fish to timers.
  fish.each { |f| timers[f] += 1 }

  days.times do
    timers = tick(timers)
  end

  puts timers.sum
end

# Simulates one day for the lantern fish timers.
def tick(timers)
  old = 0
  timers.to_enum.with_index.reverse_each do |timer, i|
    timers[i] = old
    if i.zero?
      timers[8] = timer
      timers[6] += timer
    else
      old = timer
    end
  end

  timers
end

main(256)
