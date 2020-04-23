defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count(charlist(), char()) :: non_neg_integer()
  def count(strand, nucleotide) do
    Map.get(histogram(strand), nucleotide, nil)
  end

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram(charlist()) :: map()
  def histogram(strand) do
    %{?A => Enum.count(strand, fn x -> x==?A end),
      ?T => Enum.count(strand, fn x -> x==?T end),
      ?G => Enum.count(strand, fn x -> x==?G end),
      ?C => Enum.count(strand, fn x -> x==?C end)}
  end
end
