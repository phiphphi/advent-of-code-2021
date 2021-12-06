# frozen_string_literal: true

def main()
  lines = File.readlines('input.txt', chomp: true)
  lines = lines.reject(&:empty?) # remove empty lines

  # grab called numbers
  drawn = lines.shift.split(',')



end

main
