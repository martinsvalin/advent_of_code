require 'matrix'
##
# Turn on, off or toggle regions of a 1000x1000 grid of lights.
# An instruction is in one of the following forms:
#   "turn on 0,0 through 999,999"      # => turn on all lights
#   "turn off 499,499 through 500,500" # => turn off centre square
#   "toggle 0,0 through 999,0"         # => toggle first row of lights
class Lights
  def self.count(instructions)
    new(instructions).follow_instructions.count
  end

  def initialize(instructions)
    @bit_grid = BitGrid.new size: 1000
    @instructions = instructions.map { |i| Instruction.new(i) }
  end

  def follow_instructions
    @bit_grid = @instructions.reduce(@bit_grid) do |bit_grid, instruction|
      instruction.perform_on(bit_grid)
    end
  end

  def count
    @bit_grid.count
  end
end

##
# Parses instructions into coordinates and commands to perform on the grid
class Instruction
  COORDINATES_REGEX = /(?<from_x>\d+),(?<from_y>\d+) through (?<to_x>\d+),(?<to_y>\d+)$/

  def initialize(instruction)
    @instruction = instruction
  end

  def perform_on(grid)
    case @instruction
    when /^turn on/ then grid.turn_on(from, to)
    when /^turn off/ then grid.turn_off(from, to)
    when /^toggle/ then grid.toggle(from, to)
    end
  end

  private

  def from
    [
      coordinates[:from_x].to_i,
      coordinates[:from_y].to_i
    ]
  end

  def to
    [
      coordinates[:to_x].to_i,
      coordinates[:to_y].to_i
    ]
  end

  def coordinates
    COORDINATES_REGEX.match @instruction
  end
end

##
# Represent a 2-dimensional grid of positions that can be ON or OFF, as a
# 1-dimensional number of bits. For example, 0b1010 is a 2x2 grid where the
# first column is OFF and the second column is ON. And 0b000111000 is a 3x3
# grid where the centre row is ON.
#
# The grid can have regions turned on, off or toggled by providing coordinates
# of the lower left and upper right corners of a region.
class BitGrid
  def initialize(size: 5)
    @grid = 0
    @size = size
  end

  def count
    @grid.to_s(2).count('1')
  end

  def turn_on(from, to)
    @grid |= region(from, to)
    self
  end

  def turn_off(from, to)
    @grid &= ~region(from, to)
    self
  end

  def toggle(from, to)
    @grid ^= region(from, to)
    self
  end

  def to_s
    @grid
      .to_s(2)
      .rjust((@size**2), '0')
      .scan(/.{1,#{@size}}/)
      .map(&:reverse)
      .join("\n")
  end

  private

  def region(from, to)
    from_x, from_y = from
    to_x, to_y = to

    row = (from_x..to_x)
          .map { 1 }
          .join
          .ljust(@size - from_x, '0')
          .rjust(@size, '0')

    rows = (from_y..to_y)
           .map { row }
           .join

    bottom_padding = '0' * (@size * (@size - to_y - 1))

    (rows + bottom_padding).to_i(2)
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
