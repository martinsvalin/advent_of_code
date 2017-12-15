defmodule DuelingGenerators do
  @moduledoc """
  Day 15 - Dueling Generators

  Two generators are generating numbers. Considering them pairwise, taking a
  number of pairs, how many match up their lowest 16 bits?
  """

  use Bitwise

  @a_factor 16_807
  @b_factor 48_271
  @mersenne31 2_147_483_647

  @doc """
  Count pairs with matching low 16 bits
  """
  def count_matching_low16(gen_a, gen_b, limit) do
    Stream.zip(gen_a, gen_b)
    |> Enum.take(limit)
    |> Enum.count(&low_16_match?/1)
  end

  def generator_a(seed), do: generator(seed, @a_factor)
  def generator_b(seed), do: generator(seed, @b_factor)

  def filtered_generator_a(seed), do: generator(seed, @a_factor, &mulitple_of_4?/1)
  def filtered_generator_b(seed), do: generator(seed, @b_factor, &mulitple_of_8?/1)

  defp generator(seed, factor, filter), do: generator(seed, factor) |> Stream.filter(filter)

  defp generator(seed, factor) do
    Stream.iterate(seed, &mod_m31(&1 * factor))
  end

  defp low_16_match?({a, b}) do
    (a &&& 0xFFFF) == (b &&& 0xFFFF)
  end

  defp mulitple_of_4?(n), do: (n &&& 3) == 0
  defp mulitple_of_8?(n), do: (n &&& 7) == 0

  # I benched this a bit, and there's really no noticable difference with `rem(x, @mersenne31)`
  # This implementation is only valid up to 2^62 - 1
  defp mod_m31(number) do
    case (number >>> 31) + (number &&& @mersenne31) do
      a when a < @mersenne31 -> a
      a -> a - @mersenne31
    end
  end
end
