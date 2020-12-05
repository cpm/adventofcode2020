require 'pry-byebug'

# this is variant on problem01.
# we went through all the effort to calculate the binary search for the seat
# but there was an easier way! we're just building a bitfield, so if you 
# gsub into 0/1 and then turn into base 10, this problem is free!
# Thank you, chat!
def main
  pp seats_from_line_smart("FBFBBFFRLR")
  return
end

def seats_from_line_smart(line)
  line.
    gsub("F", "0").
    gsub("B", "1").
    gsub("R", "1").
    gsub("L", "0").
    to_i(2)
end

def seat_from_line(line)
  # row_length = 128
  # if B: 64, (64,128)
  # if F: 64, (1,64)


  max_row = 127
  min_row = 0

  max_col = 7
  min_col = 0

  # we take the length between min and max
  # if it's higher half, we add half of offset to min
  # if it's lower half, we sub half of offset to max
  line.split("").each do |char|
    if char == "F"
      old_max_row = max_row
      max_row -= (max_row - min_row) / 2 + 1
      #puts "F: changing max row #{old_max_row}:#{max_row}"

    elsif char == "B"
      old_min_row = min_row
      min_row += (max_row - min_row) / 2 + 1
      #puts "B: changing min row #{old_min_row}:#{min_row}"

    elsif char == "L"
      old_max_col = max_col
      max_col -= (max_col - min_col) / 2 + 1
      #puts "L: changing max col #{old_max_col}:#{max_col}"

    elsif char == "R"
      old_min_col = min_col
      min_col += (max_col - min_col) / 2 + 1
      #puts "R: changing min col #{old_min_col}:#{min_col}"

    end
  end

  min_row * 8 + min_col
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main