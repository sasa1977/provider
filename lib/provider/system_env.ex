defmodule Provider.SystemEnv do
  # credo:disable-for-this-file Credo.Check.Readability.Specs
  @moduledoc "Provider source which retrieves values from OS env vars."

  @behaviour Provider.Source
  alias Provider.Source

  @impl Source
  def display_name(param_name, _spec), do: param_name |> Atom.to_string() |> String.upcase()

  @impl Source
  def values(params, _opts),
    do: Enum.map(params, fn {k, spec} -> k |> display_name(spec) |> System.get_env() end)

  @impl Source
  def template(params) do
    params
    |> Enum.sort()
    |> Enum.map_join("\n", &param_entry/1)
  end

  defp param_entry({name, %{default: nil} = spec}) do
    """
    # #{spec.type}
    #{display_name(name, spec)}=
    """
  end

  defp param_entry({name, spec}) do
    """
    # #{spec.type}
    # #{display_name(name, spec)}="#{String.replace(to_string(spec.default), "\n", "\\n")}"
    """
  end
end
