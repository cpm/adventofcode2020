require 'pry-byebug'

def main
  sum = 0

  current_group = []

  input_lines.each do |line|
    if line == ""
      # new group, process it!
      current_keys = ("a".."z").to_a
      current_group.each do |person|
        current_keys &= person.keys
      end

      sum += current_keys.size

      current_group = []
    else
      current_person = {}
      # form has content, add to current
      line.split("").each do |letter|
        current_person[letter] = 1
      end

      current_group << current_person
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