##
# This class calculates which floor Santa is on, given instructions
# in the form of a string of ( or ), where ( means Santa ascends one
# floor, and ) means Santa descends one floor.
class SantaFloor
  UP = '('
  DOWN = ')'

  # Input must be in the form of a string of ( and ) characters.
  def initialize(input)
    @input = input
    fail 'Bad input. All characters must be ( or ).' unless valid_input?
  end

  # Calculates the floor Santa ends up at, after following all instructions.
  def final_floor
    floors.last
  end

  # Calculates how many instructions Santa follows before finding himself
  # in the basement (floor -1).
  def basement_reached
    floors.index(-1)
  end

  private

  attr_reader :input

  def floors
    input.chars.reduce([0]) do |floors, direction|
      move(floors, direction)
    end
  end

  def move(floors, direction)
    case direction
    when UP
      floors << floors.last + 1
    when DOWN
      floors << floors.last - 1
    end
  end

  def valid_input?
    input.delete('()').empty?
  end
end

input = File.read('../input.txt').chomp
santa_floor = SantaFloor.new(input)
puts "Santa goes to floor #{santa_floor.final_floor}"
puts "Santa reaches the basement after #{santa_floor.basement_reached} moves"
