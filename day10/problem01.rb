require 'pry-byebug'

def main
  jolts = input_lines.map(&:to_i).sort

  # outlet is 0
  previous = 0
  offsets = {}
  
  jolts.each do |current|
    offset = current - previous
    offsets[offset] ||= 0
    offsets[offset] += 1

    previous = current
  end

  # jump to device
  offsets[3] += 1
  pp offsets

  puts offsets[1] * offsets[3]
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main