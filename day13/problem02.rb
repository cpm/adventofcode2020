require 'pry-byebug'

def main
  (earliest_start, schedules_csv) = input_lines

  schedule_offsets = schedules_and_offsets(schedules_csv)

  puts "Enter this into wolframalpha.com:"
  puts (
    schedule_offsets.map do |bus, offset|
    "(t + #{offset}) mod #{bus} = 0"
    end.join(", ")
  )
end

# returns array:
# [ [bus, index] ]
# lambda_time_being_tested: true|false if valid time for bus in sequence
def schedules_and_offsets(schedules) 
  schedules.split(",").map.with_index do |bus, idx|
    next if bus == "x"
    [bus.to_i, idx]
  end.compact
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main