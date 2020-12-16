require 'pry-byebug'

def main
  [2020, 30_000_000].each do |nth|
    [
      "0,3,6", "1,3,2", "1,2,3", "2,3,1", "3,2,1", "3,1,2",
      "0,12,6,13,20,1,17"
    ].each do |input|
      puts input
      pp play_game(input, nth)
      puts
    end
  end
end

def play_game(input, nth)
  original = input.split(",").map(&:to_i)

  # { value => last_turn_said }
  progress = {}
  current_value = nil
  previous_value = nil

  (0..(nth-1)).each do |turn|
    if turn < original.count
      current_value = original[turn]
    else
      last_idx = progress[current_value]

      if last_idx
        current_value = turn - 1 - last_idx 
      else
        current_value = 0
      end
    end

    progress[previous_value] = turn - 1 if previous_value
    previous_value = current_value
  end

  current_value
end

main