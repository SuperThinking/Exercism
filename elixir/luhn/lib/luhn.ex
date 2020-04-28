defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    {check, number} = String.trim(number) |> String.replace(" ", "") |> checkEdgeCases()
    case {check, number} do
      {:error, _} -> false
      {:ok, number} -> is_valid?(number)
    end
  end

  def is_valid?(number) do
    number = String.reverse(number) |> String.graphemes()
    rem(Enum.reduce(1..Enum.count(number), 0, fn x, acc ->
      if rem(x, 2) == 0 do
        num = String.to_integer(Enum.at(number, x-1)) * 2
        num = if num>9, do: num-9, else: num
        acc+num
      else
        num = String.to_integer(Enum.at(number, x-1))
        acc+num
      end
    end
    ), 10) == 0
  end

  def checkEdgeCases(number) do
    with {:ok, x} <- checkLength(number),
         {:ok, x} <- onlyNumbers(number) do
      {:ok, number}
    else
      _ -> {:error, number}
    end
  end

  def checkLength(number) do
    if String.length(number) == 1 do
      {:error, number}
    else
      {:ok, number}
    end
  end

  def onlyNumbers(number) do
    if String.replace(number, ~r/[\D]/u, "") == number do
      {:ok, number}
    else
      {:error, number}
    end
  end
end
