
class SantaFloor
  UP = '('
  DOWN = ')'

  def initialize(input)
    @input = input
    validate_input
  end

  def final_floor
    floors.last
  end

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

  def validate_input
    unless input.delete('()').empty?
      fail 'Bad input. All characters must be ( or ).'
    end
  end
end

input = File.read('../input.txt').chomp
santa_floor = SantaFloor.new(input)
puts "Santa goes to floor #{santa_floor.final_floor}"
puts "Santa reaches the basement after #{santa_floor.basement_reached} moves"
