defmodule Provider.SystemEnvTest do
  use ExUnit.Case, async: true

  alias Provider.SystemEnvTest.TestModule

  describe "generated module" do
    setup do
      Enum.each(1..7, &System.delete_env("OPT_#{&1}"))
    end

    test "load!/0 succeeds for correct data" do
      System.put_env("OPT_1", "some data")
      System.put_env("OPT_2", "42")
      System.put_env("OPT_6", "false")
      System.put_env("OPT_7", "3.14")

      assert TestModule.load!() == :ok
    end

    test "load!/0 raises on error" do
      System.put_env("OPT_2", "foobar")
      error = assert_raise RuntimeError, fn -> TestModule.load!() end
      assert error.message =~ "OPT_1 is missing"
      assert error.message =~ "OPT_2 is invalid"
      assert error.message =~ "OPT_6 is missing"
      assert error.message =~ "OPT_7 is missing"
    end

    test "access function succeed for correct data" do
      System.put_env("OPT_1", "some data")
      System.put_env("OPT_2", "42")
      System.put_env("OPT_6", "false")
      System.put_env("OPT_7", "3.14")

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
      assert_raise RuntimeError, "OPT_1 is missing", fn -> TestModule.opt_1() end
    end

    test "template/0 generates config template" do
      assert TestModule.template() ==
               """
               # string
               OPT_1=

               # integer
               OPT_2=

               # string
               # OPT_3="foo"

               # string
               # OPT_4="bar"

               # string
               # OPT_5="baz"

               # boolean
               OPT_6=

               # float
               OPT_7=
               """
    end
  end

  defmodule TestModule do
    baz = "baz"

    use Provider,
      source: Provider.SystemEnv,
      params: [
        :opt_1,
        {:opt_2, type: :integer},
        {:opt_3, default: "foo"},

        # runtime resolving of the default value
        {:opt_4, default: bar()},

        # compile-time resolving of the default value
        {:opt_5, default: unquote(baz)},
        {:opt_6, type: :boolean},
        {:opt_7, type: :float}
      ]

    defp bar, do: "bar"
  end
end
