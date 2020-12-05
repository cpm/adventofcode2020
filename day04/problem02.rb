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

  valid = passport.all? do |key, value|
    valid_field?(key, value)
  end

  valid
end

def debug_value(label, value, bool)
  puts "#{label}:#{value.inspect} = #{bool}"
end

def valid_field?(key, value)
  case key
  when "byr"
    number_between?(value, 1920, 2002).tap do |bool|
      debug_value("byr(1920..2002)", value, bool)
    end
  when "iyr"
    number_between?(value, 2010, 2020).tap do |bool|
      debug_value("iyr(2010..2020)", value, bool)
    end
  when "eyr"
    number_between?(value, 2020, 2030).tap do |bool|
      debug_value("eyr(2020..2030)", value, bool)
    end
  when "hgt"
    hgt_valid?(value).tap do |bool|
      debug_value("hgt(150cm..193cm|59in..76in)", value, bool)
    end
  when "hcl"
    (value =~ /^[#][0-9a-f]{6}$/).tap do |bool|
      debug_value("hcl(HEX)", value, bool)
    end
  when "ecl"
    %w[amb blu brn gry grn hzl oth].include?(value).tap do |bool|
      debug_value("ecl(enum)", value, bool)
    end
  when "pid"
    value =~ /^\d{9}$/
  when "cid"
    true
  else
    false
  end
end

def hgt_valid?(value)
  unit = value[-2..-1]
  return false unless %w[cm in].include?(unit)

  quantity = value[0..-3]

  if unit == "cm"
    number_between?(quantity, 150, 193)
  elsif unit == "in"
    number_between?(quantity, 59, 76)
  end
end

def number_between?(str, low, high)
  return false unless str =~ /^\d+$/

  (low..high).include?(str.to_i)
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