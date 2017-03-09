defmodule Mws.Mixfile do
  use Mix.Project

  def project do
    [app: :mws,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     preferred_cli_env: [
       vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test
     ],
     deps: deps(),
     package: package(),
     name: "MWS",
     description: "A fully-featured and responsible Amazon MWS client for Elixir",
     source_url: "https://github.com/johnhamelink/mws",
     homepage_url: "https://hexdocs.com/mws",
     docs: [
       main: "MWS",
       extras: ["README.md"]
     ]
    ]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {Mws.Application, []}]
  end

  defp package do
    [
      name: :mws,
      files: ["lib", "config", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["John Hamelink"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/johnhamelink/mws",
        "Docs"   => "https://hexdocs.pm/mws"
      }
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.11"},
      {:xml_builder, "~> 0.0.9"},
      {:elixir_xml_to_map, "~> 0.1"},
      {:csv, "~> 1.4"},
      {:timex, "~> 3.1"},
      {:xslt, "~> 0.1"},
      {:dialyxir, "~> 0.4", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.14", only: :dev},
      {:eliver, "~> 1.3.0", only: :dev},
      {:exvcr, "~> 0.8", only: [:dev, :test]},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:eye_drops, "~> 1.3", only: [:dev, :test]}
    ]
  end
end
