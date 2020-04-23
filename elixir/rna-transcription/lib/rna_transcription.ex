defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    dna = to_string(dna)
    rna = rec(dna, 0, String.length(dna), "")
    to_charlist(rna)
  end

  def rec(dna, i, len, rna) do
    if i != len do
      case String.at(dna, i) do
        "A" -> rec(dna, i+1, len, rna<>"U")
        "C" -> rec(dna, i+1, len, rna<>"G")
        "T" -> rec(dna, i+1, len, rna<>"A")
        "G" -> rec(dna, i+1, len, rna<>"C")
      end
    else
      rna
    end
  end

end
