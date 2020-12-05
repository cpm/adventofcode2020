require 'pry-byebug'

# there are 128 rows and 8 seats in each row. we have a string of BFLR and 
# doing a binary search through these seats and rows.
# B=back half of remaining rows
# F=front half of remaining rows
# L=left half of remaining seats
# R=right half of remaining seats
def main
  max = input_lines.map do |line|
    seat_from_line(line)
  end.max

  puts max
end

# let's establish our boundaries and add/subtract by half each time we cut the 
# rows/cols in half
# at the end, min=max
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

    elsif char == "B"
      old_min_row = min_row
      min_row += (max_row - min_row) / 2 + 1

    elsif char == "L"
      old_max_col = max_col
      max_col -= (max_col - min_col) / 2 + 1

    elsif char == "R"
      old_min_col = min_col
      min_col += (max_col - min_col) / 2 + 1
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