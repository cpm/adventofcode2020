require 'pry-byebug'

def main
  xmas = input_lines.map(&:to_i)

  #weakness = find_weakness(xmas, 5)
  weakness = find_weakness(xmas, 25)

  puts weakness

  summers = find_contiguous_summers(xmas, weakness)

  sum_min = summers.min
  sum_max = summers.max
  sum_sum = sum_min + sum_max

  puts "summers:"
  puts "\t min: #{sum_min}, max: #{sum_max}"
  puts "\t sum: #{sum_sum}"
end

# return: array of consecutive numbers in xmas array
#         that add up to sum
def find_contiguous_summers(xmas, sum)
  xmas.each.with_index do |num, start_idx|
    summers = [num]

    xmas[start_idx+1..-1].each do |inner_num|
      summers << inner_num

      current_sum = summers.sum
      if current_sum == sum
        return summers
      elsif current_sum > sum
        break
      end
    end
  end

  raise "couldn't find a sum that matches #{sum}"
end

def find_weakness(xmas, preamble_length)
  raise "preamble too long" unless preamble_length < xmas.length

  postamble = xmas[preamble_length..-1]

  postamble.each.with_index do |number, postamble_idx|
    preamble = xmas[postamble_idx..(postamble_idx + preamble_length)]

    if sums(preamble).none? { |sum| sum == number }
      return number
    end
  end

  raise "too strong! not weak"
end

def sums(ary)
  ary.combination(2).reject {|a, b| a == b }.map {|a, b| a + b }
end


def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main