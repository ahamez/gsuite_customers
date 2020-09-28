defmodule GsuiteCustomers.MixProject do
  use Mix.Project

  def project do
    [
      app: :gsuite_customers,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:castore, "~> 0.1"},
      {:floki, "~> 0.28.0"},
      {:html5ever, "~> 0.8.0"},
      {:jason, "~> 1.2"},
      # {:mint, "~> 1.1"},
       {:httpoison, "~> 1.6"},
      {:nimble_csv, "~> 1.0"}
    ]
  end
end
