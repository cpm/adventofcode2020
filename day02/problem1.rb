def main
  results = input_lines.find_all do |line|
    (rule_and_letter, password) = line.split(": ")
    (rule, letter) = rule_and_letter.split(" ")
    (min, max) = rule.split("-")

    char_count = password.split("").count { |char| char == letter }

    min.to_i <= char_count && char_count <= max.to_i
  end.to_a

  puts results.size
end

def input_lines
  file = File.open("input.txt")
  file.readlines.map(&:chomp)
end

main