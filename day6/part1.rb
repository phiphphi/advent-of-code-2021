# frozen_string_literal: true

RESET_FISH = 6
NEW_FISH = 8

def main(days)
  fish = File.read('input.txt').split(',').map(&:to_i)

  days.times do
    fish = tick(fish)
  end

  print fish.count
end

# Simulates one day for the lantern fish timers.
def tick(fish)
  temp = []
  fish.each do |timer|
    if timer.zero?
      temp << RESET_FISH
      temp << NEW_FISH
    else
      temp << timer - 1
    end
  end

  temp
end

main(80)
