require 'pry-byebug'

def main
  grid = input_lines.map { |line| line.split(//) }

  changed = true
  while changed
    (changed, grid) = populate_seats(grid)
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
      count = adjacent_occupied_count(grid, row: row_idx, col: col_idx)

      if value == 'L' && count == 0
        changed = true
        '#'
      elsif value == '#' && count >= 4
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
  values = begin
    (row - 1 .. row + 1).map do |try_row|
      (col - 1 .. col + 1).map do |try_col|
        # don't count the current seat!
        next if row == try_row && col == try_col

        value_at(input, row: try_row, col: try_col)
      end
    end.flatten.find_all { |value| value == '#' }.count
  end
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