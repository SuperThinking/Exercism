defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    base = String.downcase(base)
    y1 = to_charlist(base) |> Enum.sort() |> to_string()
    Enum.filter(candidates, fn x -> case x do
     str ->
      str = String.downcase(str)
      y2 = to_charlist(str) |> Enum.sort() |> to_string()
      str != base && y1 == y2
    end
  end)
  end
end
