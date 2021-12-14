# frozen_string_literal: true

def main(steps)
  lines = File.readlines('input.txt', chomp: true)
  rules = generate_rules(lines[2...lines.length])
  template = generate_template(lines[0])

  steps.times do
    template = step(template, rules)
  end

  result = count(template)
  p result.max_by { |_, v| v }[1] - result.min_by { |_, v| v }[1]
end

# Creates a new hash storing the pair insertion rules.
def generate_rules(lines)
  rules = {}

  pairs = lines.map { |rule| rule.split(' -> ') }
  pairs.each { |k, v| rules[k] = v }

  rules
end

# Processes the template into pairs.
def generate_template(line)
  line = line.chars
  pairs = Hash.new(0)

  (0...line.length - 1).each do |i|
    key = line[i] + line[i + 1]
    pairs[key] += 1
  end

  pairs
end

# Preform a pair insertion step for all pairs in the template.
def step(template, rules)
  result = Hash.new(0)

  template.each do |k, v|
    result[k[0] + rules[k]] += v
    result[rules[k] + k[1]] += v
  end

  result
end

# Returns the count for characters in the template.
def count(template)
  result = Hash.new(0)

  # Add up letters.
  template.each do |k, v|
    k.chars.each { |c| result[c] += v }
  end

  # Divide counts by two, rounding up to get true counts.
  result.map { |k, v| result[k] = (v / 2.0).ceil }

  result
end

main(40)
