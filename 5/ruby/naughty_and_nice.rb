##
# Monkey-patch String so Santa can tell nice strings from naugthy ones.
class String
  def nice?
    [
      three_or_more_vowels?,
      double_letters?,
      does_not_contain_certain_pairs?
    ].all?
  end

  def nicer?
    [
      pair_appearing_twice?,
      letter_repeating_with_one_between?
    ].all?
  end

  private

  def three_or_more_vowels?
    count('aeiou') >= 3
  end

  def double_letters?
    self =~ /(.)\1/
  end

  def does_not_contain_certain_pairs?
    self !~ /ab|cd|pq|xy/
  end

  def pair_appearing_twice?
    self =~ /(..).*\1/
  end

  def letter_repeating_with_one_between?
    self =~ /(.).\1/
  end
end

fail unless 'ugknbfddgicrmopn'.nice?
fail unless 'aaa'.nice?
fail if 'jchzalrnumimnmhp'.nice?
fail if 'haegwjzuvuyypxyu'.nice?
fail if 'dvszwmarrgswjxmb'.nice?

strings = File.readlines(File.join(__dir__, '../input.txt'))
puts "There are #{strings.count(&:nice?)} nice strings."

fail unless 'qjhvhtzxzqqjkmpb'.nicer?
fail unless 'xxyxx'.nicer?
fail if 'uurcxstgmygtbstg'.nicer?
fail if 'ieodomkazucvgmuy'.nicer?

puts "There are #{strings.count(&:nicer?)} nicer strings."
