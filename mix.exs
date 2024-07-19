defmodule Game.MixProject do
  use Mix.Project

  def project do
    [
      app: :game,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {GameApp, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.4"},
      {:req, "~> 0.5.0"},
      {:simetric, "~> 0.2.0"}
    ]
  end
end
