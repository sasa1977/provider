defmodule Provider.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Provider.Cache.ETS
    ]

    opts = [strategy: :one_for_one, name: Provider.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
