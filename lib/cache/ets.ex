defmodule Provider.Cache.ETS do
  @moduledoc """
  An ets based cache implementation
  """
  @behaviour Provider.Cache

  use GenServer

  @spec start_link(Keyword.t()) :: GenServer.server()
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl Provider.Cache
  def set(module, key, value) do
    GenServer.call(__MODULE__, {:set, module, key, value})
  end

  @impl Provider.Cache
  def get(module, key) do
    case :ets.lookup(__MODULE__, {module, key}) do
      [{{^module, ^key}, value}] -> {:ok, value}
      [] -> {:error, :not_found}
    end
  end

  @impl GenServer
  def init(:ok) do
    state = :ets.new(__MODULE__, [:named_table])

    {:ok, state}
  end

  @impl GenServer
  def handle_call({:set, module, key, value}, _from, state) do
    :ets.insert(state, {{module, key}, value})

    {:reply, :ok, state}
  end
end
