defmodule Triplet do
  @doc """
  Calculates sum of a given triplet of integers.
  """
  @spec sum([non_neg_integer]) :: non_neg_integer
  def sum(triplet) do
    Enum.sum(triplet)
  end

  @doc """
  Calculates product of a given triplet of integers.
  """
  @spec product([non_neg_integer]) :: non_neg_integer
  def product(triplet) do
    Kernel.trunc(Enum.reduce(triplet, 1, fn x, acc -> x*acc end))
  end

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?
  """
  @spec pythagorean?([non_neg_integer]) :: boolean
  def pythagorean?([a, b, c]) do
    (a*a + b*b) === c*c
  end

  def triplet?(x, y, a, b) do
    sq = :math.sqrt(x*x + y*y)
    with true <- sq == Kernel.trunc(sq),
        true <- sq >= a,
        true <- sq <= b do
        true
      else
        _ -> false
      end
  end

  def get_triplet(x, y, till, from) do
    a = y * y - x * x;
    b = 2 * y * x;
    c = y * y + x * x;
    if (c <= till) && (a >= from) && (b >= from) do
      Enum.sort([a, b, c])
    else
      nil
    end
  end

  @doc """
  Generates a list of pythagorean triplets from a given min (or 1 if no min) to a given max.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: [list(non_neg_integer)]
  def generate(min, max) do
    Enum.map(2..max, fn x ->
      Enum.map(1..(x-1), fn y -> get_triplet(y, x, max, min) end) |> Enum.filter(fn x -> x != nil end)
    end) |> Enum.reduce([], fn x, acc -> acc++x end)
  end

  @doc """
  Generates a list of pythagorean triplets from a given min to a given max, whose values add up to a given sum.
  """
  @spec generate(non_neg_integer, non_neg_integer, non_neg_integer) :: [list(non_neg_integer)]
  def generate(min, max, sum) do
    for a <- min..max, b <- min..max, c <- min..max,
      pythagorean?([a, b, c]),
      sum([a, b, c]) == sum do
        [a, b, c]
    end
    |> Enum.uniq_by(&product/1)
  end
end
