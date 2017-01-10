defmodule RedditGather.Mixfile do
  use Mix.Project

  def project do
    [app: :reddit_gather,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
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
     {:kafka_ex, "~> 0.6.1"}]
  end
end
