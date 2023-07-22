defmodule ElasticsearchApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :elasticsearch_api,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "Elasticsearch API",
      description: "Elixir library to query Elasticsearch",
      source_url: "https://github.com/GRoguelon/elasticsearch_api",
      dialyzer: dialyzer(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def dialyzer do
    [
      plt_file: {:no_warn, "priv/plts/project.plt"}
    ]
  end

  defp docs do
    [
      formatters: ["html"],
      main: "readme",
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      # These are the default files included in the package
      files: ~w[lib mix.exs README* LICENSE*],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/GRoguelon/elasticsearch_api"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:any_http, "~> 0.1"},
      {:any_json, "~> 0.2"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end
end
