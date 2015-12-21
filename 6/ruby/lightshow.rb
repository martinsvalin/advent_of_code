##
# Turn on, off or toggle regions of a 1000x1000 grid of lights.
# An instruction is in one of the following forms:
#   "turn on 0,0 through 999,999"      # => turn on all lights
#   "turn off 499,499 through 500,500" # => turn off centre square
#   "toggle 0,0 through 999,0"         # => toggle first row of lights
class Lights
  COORDINATES_REGEX = /(?<from_x>\d+),(?<from_y>\d+) through (?<to_x>\d+),(?<to_y>\d+)$/

  def self.count(instructions)
    instructions.reduce([]) do |lights, instruction|
      new(instruction).light_up(lights)
    end.count
  end

  def initialize(instruction)
    @instruction = instruction
    coordinates = COORDINATES_REGEX.match(instruction)
    fail "Invalid instruction: #{instruction}" unless coordinates
    @from_x = coordinates[:from_x].to_i
    @from_y = coordinates[:from_y].to_i
    @to_x = coordinates[:to_x].to_i
    @to_y = coordinates[:to_y].to_i
  end

  def light_up(lights)
    case instruction
    when /^turn on/ then turn_on(lights)
    when /^turn off/ then turn_off(lights)
    when /^toggle/ then toggle(lights)
    end
  end

  private

  attr_reader :instruction, :from_x, :from_y, :to_x, :to_y

  def turn_on(lights)
    lights + region
  end

  def turn_off(lights)
    lights - region
  end

  def toggle(lights)
    lights + region - (lights & region)
  end

  def region
    side_x.product(side_y)
  end

  def side_x
    (from_x..to_x).to_a
  end

  def side_y
    (from_y..to_y).to_a
  end
end

fail unless Lights.count(['turn on 0,0 through 999,999']) == 1_000_000
fail unless Lights.count(['toggle 0,0 through 999,0']) == 1_000
fail unless Lights.count(['turn off 499,499 through 500,500']).zero?
fail unless Lights.count([
  'turn on 0,0 through 999,999',
  'toggle 0,0 through 999,0',
  'turn off 499,499 through 500,500'
]) == 998_996

input = File.readlines(File.join(__dir__, '../input.txt'))
puts "There are #{Lights.count(input)} lit lights on the grid."
