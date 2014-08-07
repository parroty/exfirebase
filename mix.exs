defmodule ExFirebase.Mixfile do
  use Mix.Project

  def project do
    [ app: :exfirebase,
      version: "0.1.0",
      elixir: "~> 0.14.2 or ~> 0.15.0",
      deps: deps,
      description: description,
      package: package,
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  def deps do
    [
      {:ibrowse, github: "cmullaparthi/ibrowse"},
      {:jsex, "~> 2.0"},
      {:httpotion, "~> 0.2"},
      {:excoveralls, "~> 0.3", only: :dev},
      {:exvcr, "~> 0.2", only: [:dev, :test]},
      {:mock, github: "parroty/mock", branch: "version", only: :test}
    ]
  end

  defp description do
    """
    An elixir library for accessing the Firebase REST API.
    """
  end

  defp package do
    [ contributors: ["parroty"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/parroty/exfirebase"} ]
  end
end
