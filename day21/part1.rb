# frozen_string_literal: true

def main
  positions = File.readlines('input.txt', chomp: true)
                  .map { |l| l[-1].to_i }

  scores, turns = play(positions[0], positions[1])
  result = scores.min * (turns * 3)
  p scores
  p turns
  p result
end

def play(pos1, pos2)
  score1 = 0
  score2 = 0
  turns = 0

  while score2 < 1000
    score1, pos1, turns = roll_turn(score1, pos1, turns)
    break if score1 >= 1000

    score2, pos2, turns = roll_turn(score2, pos2, turns)
  end

  [[score1, score2], turns]
end

def roll_turn(score, pos, turns)
  roll = curr_roll(turns)
  new_pos = ((pos + roll) % 10).zero? ? 10 : (pos + roll) % 10
  [score + new_pos, new_pos, turns + 1]
end

def curr_roll(turns)
  first = turns * 3 + 1
  second = first + 1
  third = second + 1

  # Wrap all turns into the 1-100 range.
  first = (first % 100).zero? ? 100 : first % 100
  second = (second % 100).zero? ? 100 : second % 100
  third = (third % 100).zero? ? 100 : third % 100

  first + second + third
end

main
