require 'pry-byebug'

def main
  parsed = parse_lines(input_lines)

  rules = {}
  parsed[:rules].each do |rule|
    # label => [rule,..]
    rules[rule[0]] = rule[1..-1].flatten
  end

  flat_rules = parsed[:rules].map do |ary|
    ary[1..-1]
  end.flatten

  
  good_tickets = parsed[:nearby_tickets].find_all do |ticket|
    ticket.all? do |value|
      flat_rules.any? { |range| range.include?(value) }
    end
  end

  # valid fields by position
  valid_fields = rules.size.times.map do 
    rules.keys
  end

  skips = []

  good_tickets.each do |ticket|
    #binding.pry
    ticket.each.with_index do |value, idx|
      good_rule_names = rules.find_all do |label, ranges|
        ranges.any? { |range| range.include?(value) }
      end.map(&:first)

      valid_fields[idx] &= good_rule_names
    end
  end

  while true
    one_shots = valid_fields.find_all do |fields|
      fields.size == 1
    end.flatten

    puts "ONE SHOTS: "
    pp one_shots
    puts

    break if one_shots.size == valid_fields.size

    puts "valid_fields"
    pp valid_fields
    puts

    (0...valid_fields.size).each do |idx|
      field = valid_fields[idx]
      puts "valid_field[#{idx}] = #{field.inspect}"
      if field.size == 1
        "skipping #{field.inspect}"
        next
      end

      "#{field.inspect} - #{one_shots.inspect} = "
      valid_fields[idx] = field - one_shots
      pp valid_fields[idx]
    end
  end


  valid_fields = valid_fields.flatten

  pp valid_fields

  depart_indexes = valid_fields.map.with_index do |field, idx|
    idx if field =~ /departure/
  end.compact

  my_ticket = parsed[:my_ticket].flatten
  pp my_ticket

  puts "RESULT"
  puts depart_indexes.map { |idx| my_ticket[idx] }.reduce(:*)
end

# { rules: [rule,..],
#   my_ticket: ticket,
#   nearby_tickets: [ticket,...]
# }
# rule: [range,range]
# ticket: [int,...]
def parse_lines(lines)
  current_bucket = []
  buckets = [current_bucket]

  lines.each do |line|
    if line.empty?
      unless current_bucket.empty?
        current_bucket = []
        buckets << current_bucket
      end

      next
    end

    if line =~ / or /
      (label, rule) = line.split(": ")

      ranges = rule.split(" or ").map do |range_s|
        (start, stop) = range_s.split("-").map(&:to_i)
        (start..stop)
      end
      current_bucket << [label, ranges]
    elsif line =~ /,/
      current_bucket << line.split(",").map(&:to_i)
    end
  end

  {
    rules: buckets[0],
    my_ticket: buckets[1],
    nearby_tickets: buckets[2]
  }
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main