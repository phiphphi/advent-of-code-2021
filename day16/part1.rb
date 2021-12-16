# frozen_string_literal: true

def main
  bits = File.read('input.txt')

  p '100'
  p process(bits)
end

def hex_to_bin(hex)
  hex.hex.to_s(2).rjust(hex.size*4, '0')
end

# Work through the packed hexadecimals.
def process(bits)
  bits = hex_to_bin(bits).chars
  version_sum = 0
  i = 0

  # Handle each packet.
  while i < bits.length
    curr = bits[i]

    p_version, i = get_packet_slice(bits, i, 3)

    p_id, i = get_packet_slice(bits, i, 3)

    case p_id
    when 4 # Literal value.

    else # Operator.

    end

    i += 1
  end

  version_sum
end

# Retrieve the next bits of the packet from i to i + n in decimal form.
def get_packet_slice(bits, i, n)
  [bits.slice(i, i + n).to_i(2), i + n + 1]
end

main
