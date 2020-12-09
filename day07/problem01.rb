require 'pry-byebug'

def main
  hsh = {}
  input_lines.each do |line|
    (bag, contents) = parse_line(line)
    hsh[bag] = contents
  end.to_a

  pp hsh
  res = shallow_search("shiny gold", hsh).uniq - ["shiny gold"]

  pp res
  pp res.size
end

def shallow_search(needle, haystack)
  # puts "shallow_search: #{needle}"
  toplevel_bags = []

  if haystack.key?(needle)
    toplevel_bags << needle 
    # puts "haystack had #{needle}. toplevel: #{toplevel_bags.inspect}"
  end

  haystack.each do |bag, contents|
    if contents.keys.include?(needle)
      #toplevel_bags += [bag]
      # puts "bag #{bag} had #{needle}. toplevel: #{toplevel_bags.inspect}"
      toplevel_bags += shallow_search(bag, haystack)
    end
  end

  return toplevel_bags
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
    ret[bag] = quantity
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