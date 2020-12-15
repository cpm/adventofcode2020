require 'pry-byebug'

def main
  mem = Hash.new

  parsed = parse_input(input_lines)

  parsed.each do |maskset|
    and_mask = maskset[:and_mask]
    or_mask = maskset[:or_mask]

    maskset[:assignments].each do |address, value|
      value &= and_mask
      value |= or_mask

      mem[address] = value
    end
  end

  puts mem.values.sum
end

# returns:
# [ maskset, ]
# maskset = { and_mask:, or_mask:, assignments: [assignment,]}
# and_mask = mask with s/X/1/ as int
# or_mask = mask with s/X/0/ as int
# assignment = [address, value]
def parse_input(lines)
  result = []
  current_maskset = nil

  lines.each do |line|
    (operation, value) = line.split(" = ")

    if operation.start_with?("mask")
      result << current_maskset

      (and_mask, or_mask) = parse_mask(value)

      current_maskset = {
        and_mask: and_mask,
        or_mask: or_mask,
        assignments: []
      }
    elsif operation.start_with?("mem[")
      address = operation.sub("mem[", "").sub("]", "").to_i
      current_maskset[:assignments] << [
        address, value.to_i
      ]
    end
  end

  result << current_maskset

  return result.compact
end

# suppose mask is 1x0
# input OR 100 would set the 1
# input AND 110 would set the 0
# returns [and_mask, or_mask]
def parse_mask(mask)
  and_mask = mask.gsub("X", "1").to_i(2)
  or_mask = mask.gsub("X", "0").to_i(2)

  [and_mask, or_mask]
end



def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main