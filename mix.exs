defmodule Provider.MixProject do
  use Mix.Project

  def project do
    [
      app: :provider,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.2", only: [:dev, :test]},
      {:ecto, "~> 3.0"},
      {:ex_doc, "~> 0.21", only: :dev},
      {:dialyxir, "~> 0.5", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      credo: ~w/compile credo/
    ]
  end
end
