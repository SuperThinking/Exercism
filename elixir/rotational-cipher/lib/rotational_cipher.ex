defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    rec(text, 0, shift, "")
  end

  def rec(text, index, shift, new_text) do
    if index < String.length(text) do
      c = List.first(to_charlist(String.at(text, index)))
      cond do
        cap(c) == true ->
          c = c-65+shift
          rec(text, index+1, shift, new_text<>to_string([rem(c, 26) + 65]))
        small(c) == true ->
          c = c-97+shift
          rec(text, index+1, shift, new_text<>to_string([rem(c, 26) + 97]))
        true -> rec(text, index+1, shift, new_text<>String.at(text, index))
      end
    else
      new_text
    end
  end

  def cap(c) do
    c >= 65 && c <= 90
  end

  def small(c) do
    c >= 97 && c <= 122
  end
end
