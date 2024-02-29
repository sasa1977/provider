Application.put_env(:provider, :cache, Provider.ProcDictCache)
Application.put_env(:tesla, :adapter, Tesla.Mock)

ExUnit.start()
