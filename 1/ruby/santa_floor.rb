
class SantaFloor
  def initialize(input)
    @input = input
  end

  def final_floor
    floors.last
  end

  private
  attr_reader :input

  def floors
    input.chars.reduce([0]) do |floors, char|
      case char
      when '('
        floors << floors.last + 1
      when ')'
        floors << floors.last - 1
      else
        fail 'Bad input, all chars must be ( or )'
      end
    end
  end
end

input = File.read('../input.txt').chomp
santa_floor = SantaFloor.new(input)
puts "Santa goes to floor #{santa_floor.final_floor}"
