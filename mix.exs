defmodule ExFirebase.Mixfile do
  use Mix.Project

  def project do
    [ app: :exfirebase,
      version: "0.1.0",
      elixir: "~> 0.13.3",
      deps: deps(Mix.env),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  def deps(:test) do
    deps(:dev)
  end

  def deps(:dev) do
    deps(:prod) ++
      [
        {:mock, github: "parroty/mock", branch: "version"},
        {:excoveralls, "~> 0.2"},
        {:exvcr, github: "parroty/exvcr"}
      ]
  end

  def deps(:prod) do
    [
      {:ibrowse, github: "cmullaparthi/ibrowse", ref: "866b0ff5aca229f1ef53653eabc8ed1720c13cd6", override: true},
      {:json, github: "cblage/elixir-json" },
      {:httpotion, github: "myfreeweb/httpotion"}
    ]
  end
end
