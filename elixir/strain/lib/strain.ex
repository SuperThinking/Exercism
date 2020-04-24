defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun) do
    l = Enum.map(list, fun)
    rec(l, list, [], 0)
  end

  def rec(l1, l2, l3, index) do
    if index < Enum.count(l1) do
      case Enum.at(l1, index) do
        true ->
          l3 = l3++[Enum.at(l2, index)]
          rec(l1, l2, l3, index+1)
        false -> rec(l1, l2, l3, index+1)
      end
    else
      l3
    end
  end

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    l = Enum.map(list, fun)
    len = Enum.count(l)-1
    Enum.map(0..len, fn i -> if Enum.at(l, i)==false do Enum.at(list, i) end end)
    |> Enum.filter(fn x -> x != nil end)
  end
end
