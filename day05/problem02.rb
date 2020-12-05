require 'pry-byebug'

# for this problem, we take the algorithm we already had to determine the seat 
# number. we are on a full flight, so our seat is the only missing one. 
# if we find a missing seat, it's ours!
def main
  sorted_seats = input_lines.map do |line|
    seat_from_line(line)
  end.sort

  last_seat = -1

  sorted_seats.each do |seat|
    # if we skip a seat, it's our seat!
    if seat - 1 != last_seat
      puts "went from #{last_seat} to #{seat}"
    end
    last_seat = seat
  end

  pp sorted_seats
end

def seat_from_line(line)
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