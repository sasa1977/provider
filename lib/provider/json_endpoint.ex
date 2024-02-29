defmodule Provider.JsonEndpoint do
  @moduledoc """
  Provider source which retrieves values from a JSON endpoint.

  The following options are accepted.

  * :endpoint - This is the URL where the JSON configuration can be found.
  """

  @behaviour Provider.Source

  require Logger
  alias Provider.Source

  @impl Source
  def display_name(param_name, spec), do: Map.get(spec, :source, to_string(param_name))

  @impl Source
  def values(params, opts) do
    endpoint = Keyword.fetch!(opts, :endpoint)

    response =
      [{Tesla.Middleware.BaseUrl, endpoint}, Tesla.Middleware.JSON]
      |> Tesla.client()
      |> Tesla.get("")

    case response do
      {:ok, response} ->
        Enum.map(params, fn {k, spec} ->
          response.body[display_name(k, spec)]
        end)

      {:error, reason} ->
        Logger.warning("#{__MODULE__} unable to retrieve values - #{reason}")

        Enum.map(params, fn {_k, _spec} ->
          nil
        end)
    end
  end

  @impl Source
  def template(params) do
    params
    |> Enum.map(fn {k, spec} ->
      {display_name(k, spec), spec.default}
    end)
    |> Map.new()
    |> Jason.encode!()
    |> Jason.Formatter.pretty_print()
  end
end
