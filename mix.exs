defmodule ExFirebase.Mixfile do
  use Mix.Project

  def project do
    [ app: :exfirebase,
      version: "0.0.1",
      elixir: "~> 0.10.2-dev",
      deps: deps(Mix.env)
    ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  def deps(:test) do
    deps(:dev) ++
      [
        {:mock, ">= 0.0.3", github: "parroty/mock"},
        {:excoveralls, github: "parroty/excoveralls"}
      ]
  end

  def deps(:dev) do
    deps(:prod) ++
      [
        {:ex_doc, github: "elixir-lang/ex_doc"}
      ]
  end

  def deps(:prod) do
    [
      {:json, github: "cblage/elixir-json"},
      {:httpotion, github: "parroty/httpotion"},
      {:exactor, github: "sasa1977/exactor"}
    ]
  end
end
