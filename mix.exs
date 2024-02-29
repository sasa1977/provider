defmodule Provider.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :provider,
      version: @version,
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      compilers: extra_compilers() ++ Mix.compilers(),
      boundary: [externals_mode: :strict],
      dialyzer: [plt_add_apps: [:mix]],
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [
      mod: {Provider.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:boundary, "~> 0.8", runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test]},
      {:ecto, "~> 3.7"},
      {:ex_doc, "~> 0.25", only: :dev},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:jason, "~> 1.4", optional: true},
      {:tesla, "~> 1.8", optional: true}
    ]
  end

  defp aliases do
    [
      credo: ~w/compile credo/
    ]
  end

  defp extra_compilers(), do: if(Mix.env() == :prod, do: [], else: [:boundary])

  defp docs() do
    [
      main: "Provider",
      extras: ["README.md", "LICENSE", "CHANGELOG.md"],
      source_url: "https://github.com/sasa1977/provider/",
      source_ref: @version
    ]
  end

  defp package() do
    [
      description: "Managing operator configuration",
      maintainers: ["Saša Jurić"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/sasa1977/provider",
        "Changelog" =>
          "https://hexdocs.pm/provider/changelog.html##{String.replace(@version, ".", "-")}"
      }
    ]
  end
end
