require 'set'
##
# This class works out which houses Santa delivers presents to, on a grid where
# there's a house at every cell, and instructions to go up|down|left|right.
class SantaVisits
  UP = '^'
  DOWN = 'v'
  LEFT = '<'
  RIGHT = '>'

  def initialize(instructions)
    @instructions = instructions
    fail 'Bad instructions. All characters must be: v^><' if bad_instructions?
  end

  def visited
    Set.new(all_visits)
  end

  private

  attr_reader :instructions

  def all_visits
    instructions.reduce([[0, 0]]) do |visited, instruction|
      visited << new_position(*visited.last, instruction)
    end
  end

  def new_position(x, y, instruction)
    case instruction
    when UP then [x, y + 1]
    when DOWN then [x, y - 1]
    when LEFT then [x - 1, y]
    when RIGHT then [x + 1, y]
    end
  end

  def bad_instructions?
    !instructions.all? { |i| %w(v ^ > <).include? i }
  end
end

##
# Calculate the answer to part 1 and 2
module Answer
  def self.part1(input)
    SantaVisits.new(input.chars).visited.size
  end

  def self.part2(input)
    sliced = input.chars.each_slice(2).to_a
    santas = sliced.map(&:first)
    robos = sliced.map(&:last)

    (SantaVisits.new(santas).visited + SantaVisits.new(robos).visited).size
  end
end

fail unless Answer.part1('>') == 2
fail unless Answer.part1('^>v<') == 4
fail unless Answer.part1('^v^v^v^v^v') == 2

input = File.read('../input.txt').chomp
puts "Santa delivers at least one present to #{Answer.part1(input)} houses."

fail unless Answer.part2('^v') == 3
fail unless Answer.part2('^>v<') == 3
fail unless Answer.part2('^v^v^v^v^v') == 11

puts "Next year, Santa and Robo-Santa deliver to #{Answer.part2(input)} houses."
