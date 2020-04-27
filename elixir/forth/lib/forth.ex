# Can be improved :/

defmodule Forth do
  @opaque evaluator :: any

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %{
      "expression" => "",
      "dup" => :dup,
      "drop" => :drop,
      "swap" => :swap,
      "over" => :over
    }
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s = String.downcase(s) |> tokens()
    eval_rec(ev, s, [])
  end

  def eval_rec(ev, l, l_num) do
    if Enum.count(l) == 0 do
      Map.put(ev, "expression", Enum.join(l_num, " "))
    else
      [operation | tail] = l
      cond do
        (operation == "") && (tail == []) -> ev
        operation == ":" ->
          {new_ev, new_l} = new_word(ev, tail)
          eval_rec(new_ev, new_l, l_num)
        operation == "+" ->
          [a, b] = Enum.take(l_num, -2)
          l_num = Enum.take(l_num, Enum.count(l_num)-2) ++ [trunc(a+b)]
          eval_rec(ev, tail, l_num)
        operation == "-" ->
          [a, b] = Enum.take(l_num, -2)
          l_num = Enum.take(l_num, Enum.count(l_num)-2) ++ [trunc(a-b)]
          eval_rec(ev, tail, l_num)
        operation == "*" ->
          [a, b] = Enum.take(l_num, -2)
          l_num = Enum.take(l_num, Enum.count(l_num)-2) ++ [trunc(a*b)]
          eval_rec(ev, tail, l_num)
        operation == "/" ->
          [a, b] = Enum.take(l_num, -2)
          if b == 0 do
            raise Forth.DivisionByZero
          end
          l_num = Enum.take(l_num, Enum.count(l_num)-2) ++ [trunc(a/b)]
          eval_rec(ev, tail, l_num)
        operation == String.replace(operation, ~r/[\d]/u, "") ->
          words = Map.get(ev, operation)
          if words == nil do
            raise Forth.UnknownWord
          end
          cond do
            is_list(words) ->
              new_l_num = stack_manipulation(words, l_num)
              eval_rec(ev, tail, new_l_num)
            true ->
              new_l_num = stack_manipulation([words], l_num)
              eval_rec(ev, tail, new_l_num)
          end
        true ->
          l_num = l_num ++ [String.to_integer(operation)]
          eval_rec(ev, tail, l_num)
      end
    end
  end

  def stack_manipulation(words, l) do
    if Enum.count(words) == 0 do
      l
    else
      [operation | rest] = words
      case operation do
        :dup ->
          if Enum.count(l) < 1 do
            raise Forth.StackUnderflow
          end
          last_elem = List.last(l)
          stack_manipulation(rest, l ++ [last_elem])
        :drop ->
          if Enum.count(l) < 1 do
            raise Forth.StackUnderflow
          end
          {_, new_list} = List.pop_at(l, -1)
          stack_manipulation(rest, new_list)
        :swap ->
          if Enum.count(l) < 2 do
            raise Forth.StackUnderflow
          end
          [a, b] = Enum.take(l, -2)
          l = List.replace_at(l, -1, a) |> List.replace_at(-2, b)
          stack_manipulation(rest, l)
        :over ->
          if Enum.count(l) < 2 do
            raise Forth.StackUnderflow
          end
          second_last_elem = Enum.at(l, -2)
          stack_manipulation(rest, l ++ [second_last_elem])
        x ->
          stack_manipulation(rest, l ++ [x])
      end
    end
  end

  def new_word(ev, l) do
    index = Enum.find_index(l, fn x -> x == ";" end) + 1
    {[new | old], tail} = Enum.split(l, index)
    if String.replace(new, ~r/[\d]/u, "") == "" do
      raise Forth.InvalidWord
    end
    {_, old} = List.pop_at(old, -1)
    old = Enum.map(old, fn x ->
          cond do
            Map.get(ev, x) != nil -> Map.get(ev, x)
            String.replace(x, ~r/[\d]/u, "") == "" -> String.to_integer(x)
            String.trim(x) == "" -> nil
            true ->
              raise Forth.InvalidWord
              false
          end
        end
        )
    old = Enum.filter(old, fn x -> x != nil end)
    ev = Map.put(ev, new, old)
    {ev, tail}
  end

  def tokens(s) do
    String.split(s, ~r/[\pC\pZ]+/u)
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    Map.get(ev, "expression")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
