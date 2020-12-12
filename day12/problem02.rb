require 'pry-byebug'

# N/E/L is positive
# S/W/R are negative
def main
  ship_north_south = 0
  ship_east_west = 0

  waypoint_north_south = 1
  waypoint_east_west = 10
  rotation = 0

  # dir: ew x, ns y
  # top-right: positive, positive
  # top-left: negative, postive
  # bottom-left: negative, negative
  # bottom-right: positive, negative
  standard_rotations = {
    0 =>   { east_west: 1, north_south: 1 },
    90 =>  { east_west: -1, north_south: 1 },
    180 => { east_west: -1, north_south: -1 },
    270 =>   { east_west: 1, north_south: -1 },
  }

  input_lines.map do |line|
    [line[0], line[1..-1].to_i]
  end.each do |instruction, value|
    #binding.pry if instruction == "F" && value == 11

    case instruction
    when 'F'
      value.times do |v|
        ship_north_south += waypoint_north_south
        ship_east_west += waypoint_east_west
      end
    when 'N'
      waypoint_north_south += value
    when 'S'
      waypoint_north_south -= value
    when 'E'
      waypoint_east_west += value
    when 'W'
      waypoint_east_west -= value
    when 'L'
      (waypoint_east_west, waypoint_north_south) = position_after_rotation(
        waypoint_east_west, waypoint_north_south, value)

    when 'R'
      (waypoint_east_west, waypoint_north_south) = position_after_rotation(
        waypoint_east_west, waypoint_north_south, value * -1)
    else
      raise "bad instruction. oh no."
    end

    rotation += 360 while rotation < 0
    rotation -= 360 while rotation >= 360
  end

  distance = ship_north_south.abs + ship_east_west.abs

  puts distance
end

def current_direction(east_west, north_south)
  if east_west > 0 && north_south > 0
    0
  elsif east_west < 0 && north_south > 0
    90
  elsif east_west < 0 && north_south < 0
    180
  elsif east_west > 0 && north_south < 0
    270
  else
    raise "exactly 0 needs to be handled (#{east_west}, #{north_south})"
  end
end

def position_after_rotation(east_west, north_south, rotation)
  direction = current_direction(east_west, north_south)

  new_direction = rotate(direction, rotation)

  # 180 rotation keeps numbers the same
  # 90 or 270 means we swap x and y
  if (direction - new_direction).abs != 180
    (north_south, east_west) = [east_west, north_south]
  end

  if new_direction == 0
    north_south = north_south.abs
    east_west = east_west.abs
  elsif new_direction == 90
    east_west = east_west.abs * -1
    north_south = north_south.abs
  elsif new_direction == 180
    east_west = east_west.abs * -1
    north_south = north_south.abs * -1
  elsif new_direction == 270
    east_west = east_west.abs
    north_south = north_south.abs * -1
  else
    raise "new_direction = #{new_direction}?"
  end

  [east_west, north_south]
end

def rotate(current_direction, angle)
  current_direction += angle
  current_direction += 360 while current_direction < 0
  current_direction -= 360 while current_direction >= 360

  current_direction
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main