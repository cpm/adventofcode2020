require 'pry-byebug'

def main
  xmas = input_lines.map(&:to_i)

  puts find_weakness(xmas, 25)
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