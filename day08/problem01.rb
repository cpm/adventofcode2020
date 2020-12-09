require 'pry-byebug'

def main
  instructions = input_lines.map do |line|
    (instruction, int) = line.split(" ")
    [instruction, int.to_i]
  end

  seen_instructions = []
  idx = 0
  accumulator = 0

  while true
    break if seen_instructions.include?(idx)
    break if idx >= instructions.size

    seen_instructions << idx

    (instruction, int) = instructions[idx]

    if instruction == "nop"
      idx += 1
    elsif instruction == "acc"
      idx += 1
      accumulator += int
    elsif instruction == "jmp"
      idx += int
    else
      raise "invalid op code"
    end
  end

  puts accumulator
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main