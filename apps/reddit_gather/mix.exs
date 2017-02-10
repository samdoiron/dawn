defmodule RedditGather.Mixfile do
  use Mix.Project

  def project do
    [app: :reddit_gather,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
       "coveralls": :test,
       "coveralls.detail": :test,
       "coveralls.post": :test,
       "coveralls.html": :test
     ],
     elixirc_paths: elixirc_paths(Mix.env),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :kafka_ex],
     mod: {RedditGather, []}]
  end

  defp deps do
    [{:poison, "~> 2.0"},
     {:httpoison, "~> 0.10.0"},
     {:timex, "~> 3.0"},
     {:credo, "~> 0.5", only: [:dev, :test]},
     {:excoveralls, "~> 0.5", only: :test},
     {:ex_machina, "~> 1.0"},
     {:kafka_ex, "~> 0.6.1"}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
