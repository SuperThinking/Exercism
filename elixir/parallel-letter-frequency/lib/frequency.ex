defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    text = Enum.join(texts) |> String.replace(~r/[\d\W\s]/u, "") |> String.downcase()
    x = if ceil(String.length(text)/workers) == 1 do
          String.length(text)
        else
          ceil(String.length(text)/workers)
        end
    Enum.map(1..workers, fn i ->
      Task.async(fn -> calc_frequency(String.slice(text, x*(i-1)..(x*i - 1))) end)
      |> Task.await()
    end
    ) |> merge_maps()
  end

  def calc_frequency(str) do
    str
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc ->
        Map.update(acc, char, 1, &(&1 + 1))
   end)
  end

  def merge_maps(maps) do
    Enum.reduce(maps, fn map, acc -> Map.merge(map, acc, fn _k, x, y -> x+y end) end)
  end

end
