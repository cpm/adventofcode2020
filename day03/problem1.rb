def main
  # make line lines thicc enough to go down
  # 33 is a magical number we came up with because
  # the file is 323 lines tall, 30 char wide and
  # we're -1/3 slope.
  lines = input_lines.map { |line| line * 33 }

  charPosition = 0
  treeCount = 0

  lines.each do |line|
    char = line[charPosition]
    charPosition += 3

    treeCount += 1 if char == "#"
  end

  puts treeCount

  #puts lines.map(&:size)
end

def input_lines
  file = File.open("input.txt")
  file.readlines.map(&:chomp)
end

main