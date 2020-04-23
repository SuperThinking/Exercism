defmodule SecretHandshake do
  use Bitwise
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    m = %{
      1 => "wink",
      2 => "double blink",
      4 => "close your eyes",
      8 => "jump"
    }
    list = []
    list = Enum.map([0, 1, 2, 3], fn x -> Map.get(m, 1<<<x &&& code, nil) end)
    list = Enum.filter(list, fn x -> x != nil end)
    case 1<<<4 &&& code do
      16 -> Enum.reverse(list)
      _ -> list
    end
  end
end
