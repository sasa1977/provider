defmodule Provider.ProcDictCache do
  @behaviour Provider.Cache

  @impl true
  def set(mod, key, val) do
    Process.put({mod, key}, val)
  end

  @impl true
  def get(mod, key) do
    case Process.get({mod, key}, :undefined) do
      :undefined -> {:error, :not_found}
      v -> {:ok, v}
    end
  end
end
