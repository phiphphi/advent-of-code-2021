# frozen_string_literal: true

def main()
  lines = File.readlines('input.txt', chomp: true)
  lines = lines.reject(&:empty?) # Remove empty lines.

  # Grab called numbers.
  drawn = lines.shift.split(',').map(&:to_i)

  boards = add_boards(lines)
  boards = boards.map { |board| [board, 0] } # Add board won flag.

  drawn.each do |num|
    boards.each_with_index do |board, index|
      if board[1] == 0 and check_lines(board[0], num)
        board[1] = 1 # Set board won flag.
        puts "index: #{index}"
        puts calc_score(board[0], num)
      end
    end
  end
end

# Converts an array of string board lines into an array of bingo boards of five int lines.
# Each bingo board number has a flag denoting if it has been called.
def add_boards(lines)
  boards = []
  board = []
  count = 0
  lines.each do |line|
    # Board complete, load into boards.
    if count == 5
      boards << board
      board = []
      count = 0
    end

    # Add drawn flag to board numbers.
    line = line.split.map(&:to_i)
    line = line.map { |num| [num, 0] }

    board << line
    count += 1
  end

  boards << board # Load in last board.

  boards
end

# Check the number of the board has it, and if so then check for a win.
def check_lines(board, num)
  board.each do |line|
    line.each do |pair|
      if pair[0] == num # Match found. Set drawn flag and check for win.
        pair[1] = 1
        # Check rows and columns for a win.
        return true if check_win(board) || check_win(board.transpose)
      end
    end
  end

  false
end

# Check if this board has a winning row or column of marked numbers.
def check_win(board)
  board.each do |line|
    sum = 0
    line.each do |pair|
      sum += pair[1]
    end

    return true if sum == 5
  end

  false
end

# Sums up all the unmarked numbers on the board and multiply by the last called number.
def calc_score(board, num)
  unmarked = 0
  board.each do |line|
    line.each do |pair|
      unmarked += pair[0] if (pair[1]).zero?
    end
  end

  unmarked * num
end

main
