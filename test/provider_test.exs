defmodule ProviderTest do
  use ExUnit.Case, async: true
  alias Provider

  describe "fetch_all" do
    test "returns correct values" do
      param1 = param_spec()
      param2 = param_spec(type: :integer)
      param3 = param_spec(type: :float, default: 3.14)

      System.put_env(param1.os_env_name, "some value")
      System.put_env(param2.os_env_name, "42")

      params = Enum.into([param1, param2, param3], %{}, &{&1.name, &1.opts})

      assert Provider.fetch_all(Provider.SystemEnv, params, []) ==
               {:ok, %{param1.name => "some value", param2.name => 42, param3.name => 3.14}}
    end

    test "reports errors" do
      param1 = param_spec()
      param2 = param_spec(type: :integer, default: 42)
      param3 = param_spec(type: :float)

      System.put_env(param3.os_env_name, "invalid value")

      params = Enum.into([param1, param2, param3], %{}, &{&1.name, &1.opts})

      assert Provider.fetch_all(Provider.SystemEnv, params, []) ==
               {:error, Enum.sort([error(param1, "is missing"), error(param3, "is invalid")])}
    end
  end

  defp param_spec(overrides \\ []) do
    name = :"test_env_#{System.unique_integer([:positive, :monotonic])}"
    opts = Map.merge(%{type: :string, default: nil}, Map.new(overrides))
    os_env_name = name |> to_string() |> String.upcase()
    %{name: name, opts: opts, os_env_name: os_env_name}
  end

  defp error(param, message), do: "#{param.os_env_name} #{message}"
end
