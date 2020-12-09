require 'pry-byebug'

def main
  instructions = input_lines.map do |line|
    (instruction, int) = line.split(" ")
    [instruction, int.to_i]
  end

  instructions.each.with_index do |instruction, idx|
    run_program(instructions, idx)
  end
end

def run_program(instructions, flip_instruction)
  seen_instructions = []

  idx = 0
  accumulator = 0

  while true
    break if seen_instructions.include?(idx)

    if idx >= instructions.size
      raise "successfully exited the program: #{accumulator}"
    end

    seen_instructions << idx

    (instruction, int) = instructions[idx]

    if instruction == "nop"
      if flip_instruction == idx
        idx += int
      else
        idx += 1
      end
    elsif instruction == "acc"
      idx += 1
      accumulator += int
    elsif instruction == "jmp"
      if flip_instruction == idx
        idx += 1
      else
        idx += int
      end
    else
      raise "invalid op code"
    end
  end
  
  return accumulator
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main