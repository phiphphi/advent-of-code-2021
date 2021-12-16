def main
  bits = hex_to_bin(File.read('input.txt'))

  # Handle outer packet.
  result, _ = process_single(bits, 0)
  p result
end

def hex_to_bin(hex)
  hex.hex.to_s(2).rjust(hex.size * 4, '0')
end

# Process a single packet.
def process_single(bits, start)
  p_version, start = get_packet_slice(bits, start, 3)

  p_id, start = get_packet_slice(bits, start, 3)

  case p_id
  when 4 # Literal value.
    _, start = process_literal(bits, start)
  else # Operator.
    result, start = process_operator(bits, start, p_id)
    p_version += result
  end

  [p_version, start]
end

# Retrieve the next bits of the packet from i to i + n in decimal form.
def get_packet_slice(bits, i, n)
  slice = bits[i...i + n]
  i += n
  [slice.to_i(2), i]
end

# Process a literal packet value.
def process_literal(bits, i)
  literals = []

  while bits[i] == '1'
    literals << bits[i + 1..i + 4]
    i += 5
  end

  # Add on last sequence after 0.
  literals << bits[i + 1..i + 4]
  i += 5
  [literals.join.to_i(2), i]
end

# Process an operator packet.
def process_operator(bits, start, operator)
  type_id, start = get_packet_slice(bits, start, 1)
  process_subpackets(bits, start, type_id)
end

# Gets a list of the subpackets inside this packet.
def process_subpackets(bits, start, type_id)
  version_sum = 0

  if type_id.zero? # Subpackets in bits.
    length, start = get_packet_slice(bits, start, 15)
    stop = start + length
    while start < stop
      result, start = process_single(bits, start)
      version_sum += result
    end
  else # Subpackets in length.
    count, start = get_packet_slice(bits, start, 11)
    count.times do
      result, start = process_single(bits, start)
      version_sum += result
    end
  end

  [version_sum, start]
end

main