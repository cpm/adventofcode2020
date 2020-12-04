def main
  result = 1
  [1.0, 3.0, 5.0, 7.0, 0.5].each do |inverse_slope|
    result *= tree_count( inverse_slope: inverse_slope )
  end

  puts result
end

def tree_count(inverse_slope: )
  multiplier = line_multiplier(input_lines, inverse_slope)
  lines = input_lines.map { |line| line * multiplier }

  charPosition = 0
  treeCount = 0

  lines.each do |line|
    if (charPosition % 1).zero?
      char = line[charPosition.to_i]
      treeCount += 1 if char == "#"
    end
    charPosition += inverse_slope
  end

  treeCount
end

# inverse slope is run / rise as float
def line_multiplier(lines, inverse_slope)
  line_length = lines[0].size.to_f
  (lines.size * inverse_slope / line_length).ceil
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main