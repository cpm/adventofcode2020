require 'pry-byebug'

def main
  grid = input_lines.map { |line| line.split(//) }

  @count = 0
  changed = true
  while changed
    (changed, grid) = populate_seats(grid)
    puts @count
    pg grid
    puts; puts; puts
    @count += 1
  end

  puts grid.flatten.find_all { |c| c == '#' }.size
end

def pg(grid)
  grid.each do |ary|
    puts ary.join("")
  end
end

def populate_seats(grid)
  changed = false
  new_grid = grid.map.with_index do |row, row_idx|
    row.map.with_index do |value, col_idx|
      #binding.pry if @count == 2

      count = adjacent_occupied_count(grid, row: row_idx, col: col_idx)

      if value == 'L' && count == 0
        changed = true
        '#'
      elsif value == '#' && count >= 5
        changed = true
        'L'
      else
        value
      end
    end
  end

  [changed, new_grid]
end

# given coords, return number of occupied seats
def adjacent_occupied_count(input, row:, col:)
  [-1, 0, 1].map do |row_dir|
    [-1, 0, 1].map do |col_dir|
      occupied_in_direction?(input,
        row: row, col: col,
        col_direction: col_dir, row_direction: row_dir
      )
    end
  end.flatten.find_all { |value| value }.size
  # flatten out the array, find all true results, and count them
end

# is there an occupied seat in this direction?
def occupied_in_direction?(grid, row:, col:, row_direction:, col_direction:)
  return false if row_direction == 0 && col_direction == 0

  found_occupied = false

  while true
    row += row_direction
    col += col_direction

    value = value_at(grid, row: row, col: col)

    return false unless value
    return true if value == '#'
    return false if value == 'L'
  end

  raise "should never get here"
end

def value_at(input, row:, col:)
  return nil if row < 0 || col < 0
  return nil unless input[row]

  input[row][col]
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main