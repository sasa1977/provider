defmodule Provider.Cache do
  @moduledoc """
  Defines a behaviour for cache implementations to follow
  """

  @callback set(mod :: module(), key :: atom(), value :: term()) :: :ok
  @callback get(mod :: module(), key :: atom()) :: {:ok, term()} | {:error, :not_found}

  @spec set(module(), atom(), term()) :: :ok
  def set(mod, key, value) do
    impl().set(mod, key, value)
  end

  @spec get(module(), atom()) :: {:ok, term()} | {:error, :not_found}
  def get(mod, key) do
    impl().get(mod, key)
  end

  defp impl do
    Application.get_env(:provider, :cache, Provider.Cache.ETS)
  end
end
