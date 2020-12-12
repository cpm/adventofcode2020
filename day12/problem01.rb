require 'pry-byebug'

# N/E/L is positive
# S/W/R are negative
def main
  north_south = 0
  east_west = 0
  rotation = 0

  standard_rotations = {
    0 => { north_south: 0, east_west: 1 },
    90 => { north_south: 1, east_west: 0 },
    180 => { north_south: 0, east_west: -1 },
    270 => { north_south: -1, east_west: 0 },
  }
  input_lines.map do |line|
    [line[0], line[1..-1].to_i]
  end.each do |instruction, value|
    #binding.pry if instruction == "F" && value == 11

    case instruction
    when 'F'
      north_south += value * standard_rotations[rotation][:north_south]
      east_west += value * standard_rotations[rotation][:east_west]
    when 'N'
      north_south += value
    when 'S'
      north_south -= value
    when 'E'
      east_west += value
    when 'W'
      east_west -= value
    when 'L'
      rotation += value
    when 'R'
      rotation -= value
    else
      raise "bad instruction. oh no."
    end

    rotation += 360 while rotation < 0
    rotation -= 360 while rotation >= 360
  end

  distance = north_south.abs + east_west.abs

  puts distance
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main