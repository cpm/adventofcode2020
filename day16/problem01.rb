require 'pry-byebug'

def main
  parsed = parse_lines(input_lines)

  rules = parsed[:rules].flatten

  bad_values = parsed[:nearby_tickets].map do |ticket|
    ticket.find_all do |value|
      rules.none? { |range| range.include?(value) }
    end
  end

  pp bad_values.flatten.sum
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
    line = line.gsub(/[a-zA-Z0-9 ]+: /, "")

    if line.empty?
      unless current_bucket.empty?
        current_bucket = []
        buckets << current_bucket
      end

      next
    end

    if line =~ / or /
      ranges = line.split(" or ").map do |range_s|
        (start, stop) = range_s.split("-").map(&:to_i)
        (start..stop)
      end
      current_bucket << ranges
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