def main
  results = input_lines.find_all do |line|
    (rule_and_letter, password) = line.split(": ")
    (rule, letter) = rule_and_letter.split(" ")
    (pos1, pos2) = rule.split("-").map(&:to_i)

    char_at_position?( str: password, char: letter, pos: pos1) ^
    char_at_position?( str: password, char: letter, pos: pos2)
  end.to_a

  puts results.size
end

def char_at_position?(str:, char:, pos:)
  return if pos < 1
  return if pos > str.size

  idx = pos - 1

  str.split("")[idx] == char
end

def input_lines
  file = File.open("input.txt")
  file.readlines.map(&:chomp)
end

main