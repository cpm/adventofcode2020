require 'pry-byebug'

def main
  (earliest_start, schedules_csv) = input_lines

  earliest_start = earliest_start.to_i
  buses = schedules_csv.split(",").reject do |num|
    num == "x"
  end.map(&:to_i).uniq.sort

  (time, bus)= find_bus(earliest_start, buses)


  puts "matching bus: #{bus}@#{time}"

  result = (time - earliest_start) * bus
  puts result
end

def find_bus(earliest_start, buses)
  # iterate infinitely until we find a bus
  (earliest_start..).each do |time|
    # find the time bus that's a multiple of any scheduled bus
    matching_bus = buses.detect do |bus|
      (time % bus) == 0
    end

    return [time, matching_bus] if matching_bus
  end

  raise "did not find any buses"
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main