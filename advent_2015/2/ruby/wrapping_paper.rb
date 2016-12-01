##
# This class represents a present, and lets us find out
# how much wrapping paper or ribbon is needed for it.
class Present
  attr_reader :l, :w, :h

  def initialize(l, w, h)
    @l = l.to_i
    @w = w.to_i
    @h = h.to_i
  end

  # Square feet of wrapping needed for the present
  def wrapping
    sides.reduce(:+) + sides.min / 2
  end

  # Feet of ribbon needed for the present
  def ribbon
    perimeters.min + volume
  end

  private

  def sides
    [
      2 * l * w,
      2 * w * h,
      2 * l * h
    ]
  end

  def perimeters
    [
      2 * l + 2 * w,
      2 * w + 2 * h,
      2 * l + 2 * h
    ]
  end

  def volume
    l * w * h
  end
end

##
# This class holds and acts on a collection of Presents
class AllPresents
  attr_reader :present_dimensions

  # Takes a string of presents, one per row. Each row should look
  # like e.g. "1x2x3", where width is 1, height is 2, length is 3.
  def initialize(input)
    @present_dimensions = input.split("\n")
  end

  # The total square feet of wrapping needed for all presents.
  def wrapping
    presents
      .map(&:wrapping)
      .reduce(:+)
  end

  # The total feet of ribbon needed for all presents.
  def ribbon
    presents
      .map(&:ribbon)
      .reduce(:+)
  end

  private

  def presents
    @present ||= present_dimensions.map do |p|
      Present.new(*p.split('x'))
    end
  end
end

presents = AllPresents.new File.read(File.join __dir__, '../input.txt').chomp
puts "We need #{presents.wrapping} square feet of wrapping"
puts "We need #{presents.ribbon} feet of ribbon"
