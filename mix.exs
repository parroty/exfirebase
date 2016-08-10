defmodule ExFirebase.Mixfile do
  use Mix.Project

  def project do
    [ app: :exfirebase,
      version: "0.4.1",
      elixir: "~> 1.0",
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
      {:ibrowse, "~> 4.2"},
      {:exjsx, "~> 3.2"},
      {:httpotion, "~> 3.0.0"},
      {:excoveralls, "~> 0.5.5", only: :test},
      {:exvcr, "~> 0.8.1", only: :test},
      {:mock, "~> 0.1.3", only: :test, branch: "fix"}
    ]
  end

  defp description do
    """
    An elixir library for accessing the Firebase REST API.
    """
  end

  defp package do
    [ maintainers: ["parroty"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/parroty/exfirebase"} ]
  end
end
