defmodule Bob do
  def hey(input) do
    cond do
      nothing(input) ->
        "Fine. Be that way!"
      question(input) ->
        cond do
          shouting(input) ->
            "Calm down, I know what I'm doing!"
          true ->
            "Sure."
        end
      shouting(input) ->
        "Whoa, chill out!"
      true ->
        "Whatever."
    end
  end

  def shouting(input) do
    (String.upcase(input) === input) && (containsChar(input) != true)
  end

  def containsChar(input) do
    String.replace(input, ~r/[\d\W\s]/u, "") |> nothing()
  end

  def question(input) do
    String.trim(input) |> String.graphemes() |> List.last() === "?"
  end

  def nothing(input) do
    String.trim(input) |> String.length() === 0
  end
end
