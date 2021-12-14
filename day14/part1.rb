# frozen_string_literal: true

def main(steps)
  lines = File.readlines('input.txt', chomp: true)
  template = lines[0]
  rules = generate_rules(lines[2...lines.length])

  steps.times do
    template = step(template, rules)
  end

  count = template.chars.uniq.map { |i| template.count(i) }
  p count.max - count.min
end

# Creates a new hash storing the pair insertion rules.
def generate_rules(lines)
  rules = {}

  pairs = lines.map { |rule| rule.split(' -> ') }
  pairs.each { |k, v| rules[k] = v }

  rules
end

# Preform a pair insertion step for all pairs in the template.
def step(template, rules)
  template = template.chars
  result = Array.new(template.length + template.length - 1)

  (0...template.length - 1).each do |i|
    first = template[i]
    second = template[i + 1]

    result[i * 2] = first
    result[(i * 2) + 1] = rules[first + second]
    result[(i + 1) * 2] = second
  end

  result.join
end

main(10)
