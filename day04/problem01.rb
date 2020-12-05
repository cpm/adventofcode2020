require 'pry-byebug'

def main
  valid_passports = 0
  total_passports = 0

  current_passport = {}
  input_lines.each do |line|
    if line == ""
      valid_passports += 1 if passport_valid?(current_passport)
      total_passports += 1
      current_passport = {}
    else
      current_passport = current_passport.merge(line_to_hsh(line))
    end
  end

  puts "valid: #{valid_passports}"
  puts "total: #{total_passports}"
end

def passport_valid?(passport)
  required_fields = %w[
    byr
    iyr
    eyr
    hgt
    hcl
    ecl
    pid
  ]

  # optional_fields = %w[cid]

  return false unless required_fields.all? do |field|
    passport.key?(field) 
  end

  true
end

def line_to_hsh(current_line)
  hsh = {}
  current_line.split(" ").each do |pair|
    (key, value) = pair.split(":")
    hsh[key] = value
  end

  hsh
end

def input_lines
  @_input_lines ||= begin
    file = File.open("input.txt")
    file.readlines.map(&:chomp)
  end
end

main