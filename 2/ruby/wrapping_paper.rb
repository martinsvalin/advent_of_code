class Present
  attr_reader :l, :w, :h

  def initialize(l, w, h)
    @l, @w, @h = l.to_i, w.to_i, h.to_i
  end

  def wrapping
    sides.reduce(:+) + sides.min
  end

  def ribbon
    perimeters.min + volume
  end

  private

  def sides
    [l*w, w*l, w*h, h*w, l*h, h*l]
  end

  def perimeters
    [2*l + 2*w, 2*w + 2*h, 2*l + 2*h]
  end

  def volume
    l * w * h
  end
end

class AllPresents
  attr_reader :present_dimensions

  def initialize(input)
    @present_dimensions = input.split("\n")
  end

  def wrapping
    presents
      .map(&:wrapping)
      .reduce(:+)
  end

  def ribbon
    presents
      .map(&:ribbon)
      .reduce(:+)
  end

  private

  def presents
    @present ||= present_dimensions.map { |p| Present.new *p.split('x') }
  end
end

presents = AllPresents.new File.read(File.join __dir__, '../input.txt').chomp
puts "We need #{presents.wrapping} square feet of wrapping"
puts "We need #{presents.ribbon} feet of ribbon"
