# frozen_string_literal: true

def main
  line = File.read('input.txt')
  target = get_target(line)
  
  y_min = target[1][0]
  p get_triangular_num(y_min)
end

def get_target(line)
  line = line.delete_prefix('target area: ')
  line = line.split(' ')
  line[0] = line[0].delete_prefix('x=').split('..').map(&:to_i)
  line[1] = line[1].delete_prefix('y=').split('..').map(&:to_i)
  [line[0], line[1]]
end

def get_triangular_num(num)
  num * (num + 1) / 2
end

main
