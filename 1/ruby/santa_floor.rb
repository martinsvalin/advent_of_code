
class SantaFloor
  def initialize(input)
    @input = input
  end

  def final_floor
    up - down
  end

  private
  attr_reader :input

  def up
    input.count ?(
  end

  def down
    input.count ?)
  end
end

input = File.read('../input.txt').chomp
santa_floor = SantaFloor.new(input)
puts "Santa goes to floor #{santa_floor.final_floor}"
