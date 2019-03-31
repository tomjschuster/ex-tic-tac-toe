defmodule TicTacToe.MixProject do
  use Mix.Project

  def project do
    [
      app: :tic_tac_toe,
      version: "0.1.0",
      elixir: "~> 1.5",
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {TicTacToe.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, github: "phoenixframework/phoenix", branch: "v1.4", override: true},
      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.13", github: "phoenixframework/phoenix_html", override: true},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:cowboy, "~> 2.0"}
    ]
  end
end
