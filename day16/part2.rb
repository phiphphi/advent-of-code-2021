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
    result, start = process_literal(bits, start)
  else # Operator.
    result, start = process_operator(bits, start, p_id)
  end

  [result, start]
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
  packets, start = process_subpackets(bits, start, type_id)

  result = 0
  case operator
  when 0
    result = packets.sum
  when 1
    result = packets.inject(:*)
  when 2
    result = packets.min
  when 3
    result = packets.max
  when 5
    result = packets[0] > packets[1] ? 1 : 0
  when 6
    result = packets[0] < packets[1] ? 1 : 0
  when 7
    result = packets[0] == packets[1] ? 1 : 0
  end

  [result, start]
end

# Gets a list of the subpackets inside this packet.
def process_subpackets(bits, start, type_id)
  packets = []

  if type_id.zero? # Subpackets in bits.
    length, start = get_packet_slice(bits, start, 15)
    stop = start + length
    while start < stop
      result, start = process_single(bits, start)
      packets << result
    end
  else # Subpackets in length.
    count, start = get_packet_slice(bits, start, 11)
    count.times do
      result, start = process_single(bits, start)
      packets << result
    end
  end

  [packets, start]
end

main
