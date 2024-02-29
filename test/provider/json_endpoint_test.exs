defmodule Provider.JsonEndpointTest do
  use ExUnit.Case

  alias Provider.JsonEndpointTest.TestModule

  describe "generated module" do
    test "load!/0 succeeds for correct data" do
      Tesla.Mock.mock(fn %{method: :get} ->
        %Tesla.Env{
          status: 200,
          body: %{"opt_1" => "some data", "opt_2" => 42, "opt_6" => false, "opt7" => 3.14}
        }
      end)

      assert TestModule.load!() == :ok
    end

    test "load!/0 raises on error" do
      Tesla.Mock.mock(fn %{method: :get} ->
        %Tesla.Env{
          status: 200,
          body: %{"opt_2" => "foobar"}
        }
      end)

      System.put_env("OPT_2", "foobar")
      error = assert_raise RuntimeError, fn -> TestModule.load!() end

      assert error.message =~ "opt_1 is missing"
      assert error.message =~ "opt_2 is invalid"
      assert error.message =~ "opt_6 is missing"
      assert error.message =~ "opt7 is missing"
    end

    test "access function succeed for correct data" do
      Tesla.Mock.mock(fn %{method: :get} ->
        %Tesla.Env{
          status: 200,
          body: %{"opt_1" => "some data", "opt_2" => 42, "opt_6" => false, "opt7" => 3.14}
        }
      end)

      TestModule.load!()

      assert TestModule.opt_1() == "some data"
      assert TestModule.opt_2() == 42
      assert TestModule.opt_3() == "foo"
      assert TestModule.opt_4() == "bar"
      assert TestModule.opt_5() == "baz"
      assert TestModule.opt_6() == false
      assert TestModule.opt_7() == 3.14
    end

    test "access function raises for on error" do
      assert_raise RuntimeError, "opt_1 is missing", fn -> TestModule.opt_1() end
    end

    test "template/0 generates config template" do
      assert TestModule.template() ==
               ~s|{
  \"opt7\": null,
  \"opt_1\": null,
  \"opt_2\": null,
  \"opt_3\": \"foo\",
  \"opt_4\": \"bar\",
  \"opt_5\": \"baz\",
  \"opt_6\": null
}|
    end
  end

  defmodule TestModule do
    baz = "baz"

    use Provider,
      source: {Provider.JsonEndpoint, [endpoint: bar()]},
      params: [
        :opt_1,
        {:opt_2, type: :integer},
        {:opt_3, default: "foo"},

        # runtime resolving of the default value
        {:opt_4, default: bar()},

        # compile-time resolving of the default value
        {:opt_5, default: unquote(baz)},
        {:opt_6, type: :boolean},
        {:opt_7, type: :float, source: "opt7"}
      ]

    defp bar, do: "bar"
  end
end
