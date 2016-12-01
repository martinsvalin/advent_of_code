require 'digest'
##
# Mine AdventCoin by finding the first number that,
# when appended to the key and MD5 hashed, produces
# a hexadecimal MD5 hash starting with five zeroes.
class AdventCoin
  def self.mine(key, prefix_size = 5)
    new(key, prefix_size).first_hit
  end

  def initialize(key, prefix_size)
    @key = key
    @prefix = '0' * prefix_size
    @size = prefix_size
  end

  def first_hit
    attempts.find { |_n, digest| digest[0, size] == prefix }.first
  end

  private

  attr_reader :key, :prefix, :size

  def attempts
    all_numbers.map do |n|
      [n, md5_digest(n)]
    end
  end

  def all_numbers
    (1..Float::INFINITY).lazy
  end

  def md5_digest(n)
    Digest::MD5.hexdigest([key, n].join)
  end
end

def check(key, expected)
  actual = AdventCoin.mine(key)
  fail "Drats! Expected #{expected}, got #{actual}." if actual != expected
end

check 'abcdef', 609_043
check 'pqrstuv', 1_048_970

my_key = 'yzbqklnj'
part1 = AdventCoin.mine(my_key, 5)
part2 = AdventCoin.mine(my_key, 6)
puts "AdventCoin with five leading zeroes found at #{part1} for #{my_key}."
puts "AdventCoin with six leading zeroes found at #{part2} for #{my_key}."
