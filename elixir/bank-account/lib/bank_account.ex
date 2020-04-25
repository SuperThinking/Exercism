defmodule BankAccount do
  use Task
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = GenServer.start_link(BankProcess, %{
      :balance => 0,
      :is_open => true
    })
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    case Process.alive?(account) do
      true -> GenServer.stop(account)
      false -> {:error, :account_closed}
    end
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    case Process.alive?(account) do
      true -> GenServer.call(account, :balance)
      false -> {:error, :account_closed}
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    case Process.alive?(account) do
      true -> GenServer.cast(account, {:update, amount})
      false -> {:error, :account_closed}
    end
  end
end


defmodule BankProcess do
  use GenServer

  @impl true
  def init(passbook) do
    {:ok, passbook}
  end

  @impl true
  def handle_call(:balance, from, passbook) do
    {:reply, Map.get(passbook, :balance), passbook}
  end

  @impl true
  def handle_cast({:update, amount}, passbook) do
    {:noreply, Map.put(passbook, :balance, Map.get(passbook, :balance) + amount)}
  end

end
