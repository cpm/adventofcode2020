require 'pry-byebug'

def main
  sum = 0
  current_group = {}

  input_lines.each do |line|
    if line == ""
      sum += current_group.size

      current_group = {}
    else
      # form has content, add to current
      line.split("").each do |letter|
        current_group[letter] = 1
      end
    end
  end

  puts sum
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main