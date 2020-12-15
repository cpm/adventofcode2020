require 'pry-byebug'

def main
  mem = Hash.new

  parsed = parse_input(input_lines)

  parsed.each do |maskset|
    maskset[:assignments].each do |address, value|
      maskset[:masks].each do |and_mask, or_mask|
        transformed_address = (address & and_mask)
        transformed_address |= or_mask
        mem[transformed_address] = value
      end
    end
  end

  pp mem
  puts mem.values.sum
end

# returns:
# [ maskset, ]
# maskset = { masks: [], assignments: [assignment,]}
# masks: [ [and, or], ...]
# and= mask to AND with address
# or= mask to OR with address
# assignment = [address, value]
def parse_input(lines)
  result = []
  current_maskset = nil

  lines.each do |line|
    (operation, value) = line.split(" = ")

    if operation.start_with?("mask")
      result << current_maskset

      andors_ary = parse_mask(value)

      current_maskset = {
        masks: andors_ary,
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

# mask values = 0,1,X
# do not change
# force 1
# force 0
def explode_mask(mask)
  mask = mask.gsub("X", "Y").gsub("0", "X")

  y_indexes = mask.split("").map.with_index do |bit, idx|
    idx if bit == "Y"
  end.compact

  %w[0 1].repeated_permutation(y_indexes.size).map do |perm|
    new_mask = "#{mask}"

    perm.each.with_index do |bit, idx|
      new_mask[y_indexes[idx]] = bit
    end

    new_mask
  end
end

def turn_mask_into_and_or(mask)
  and_mask = mask.gsub("X", "1").to_i(2)
  or_mask = mask.gsub("X", "0").to_i(2)

  [and_mask, or_mask]
end

# returns: [ andor, ...]
# andor: [and, or]
def parse_mask(mask)
  explode_mask(mask).map do |exploded|
    turn_mask_into_and_or(exploded)
  end
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main