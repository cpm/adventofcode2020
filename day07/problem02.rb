require 'pry-byebug'

def main
  hsh = {}
  input_lines.each do |line|
    (bag, contents) = parse_line(line)
    hsh[bag] = contents
  end.to_a

  pp count_nested_bags("shiny gold", hsh) - 1
end

def count_nested_bags(needle, bag_topology)
  sum = 1

  bag_topology[needle].each do |bag, quantity|
    quantity.times do |n|
      sum += count_nested_bags(bag, bag_topology)
    end
  end

  sum
end

# BAG = WORD COLOR bag(s)?.
# BAG_QUANTITY = INT BAG
# BAG_CONTENTS =
#   (BAG_QUANTITY) |
#   (BAG_QUANTITY, ){0,} BAG_QUANTITY)  |
#   no other bags

# LINE = BAG contains BAG_CONTENTS.
# returns:
#   [BAG, { BAG => quantity} ]

def parse_line(line)
  # ex: light red bags contain 1 bright white bag, 2 muted yellow bags.

  ret = {}
  # chop off the period at the end and all bag|bags
  # light red contain 1 bright white, 2 muted yellow
  line = line[0..-2].gsub(/ bags?/, "")

  # container = light red
  # rest = 1 bright white, 2 muted yellow
  (container, rest) = line.split(" contain ")

  [container, parse_rest(rest)]
end

def parse_rest(rest)
  return {} if rest == "no other"

  ret = {}

  rest.split(", ").each do |bag_quantity|
    (quantity, bag) = bag_quantity.split(" ", 2)
    ret[bag] = quantity.to_i
  end

  return ret
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main