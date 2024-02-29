defmodule Provider.Cache.ETSTest do
  use ExUnit.Case, async: false

  alias Provider.Cache.ETS

  describe "get/2" do
    test "returns an error tuple if not value is found" do
      assert {:error, :not_found} = ETS.get(__MODULE__, :key_not_found)
    end
  end

  describe "set/3" do
    test "retrieves the value after it has been set" do
      assert :ok == ETS.set(__MODULE__, :set_success_1, "value")
      assert :ok == ETS.set(__MODULE__, :set_success_2, 42)
      assert :ok == ETS.set(__MODULE__, :set_success_3, true)
      assert :ok == ETS.set(__MODULE__, :set_success_4, 3.14)

      assert {:ok, "value"} = ETS.get(__MODULE__, :set_success_1)
      assert {:ok, 42} = ETS.get(__MODULE__, :set_success_2)
      assert {:ok, true} = ETS.get(__MODULE__, :set_success_3)
      assert {:ok, 3.14} = ETS.get(__MODULE__, :set_success_4)
    end

    test "overwrites a given key" do
      assert :ok == ETS.set(__MODULE__, :set_success_1, "value1")
      assert {:ok, "value1"} = ETS.get(__MODULE__, :set_success_1)

      assert :ok == ETS.set(__MODULE__, :set_success_1, "value2")
      assert {:ok, "value2"} = ETS.get(__MODULE__, :set_success_1)
    end
  end
end
