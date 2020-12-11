require 'pry-byebug'

def main
  jolts = input_lines.map(&:to_i)

  # outlet is 0
  start = 0
  destination = jolts.max + 3

  pp arrangement_count_from(start, destination, input: jolts)
end

# find the number of valid arrangements starting from 
# `jolt` can be found in input:
def arrangement_count_from(start, destination, input:)
  @_cache ||= {}

  @_cache[start] ||= begin
    (1..3).map do |offset|
      new_start = start + offset

      # is there a path forward in this input?
      if input.include?(new_start)
        arrangement_count_from(new_start, destination, input: input)
      # if we're at the end
      elsif new_start == destination
        1
      else
        0
      end
    end.sum
  end
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main