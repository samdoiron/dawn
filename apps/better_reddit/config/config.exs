# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :better_reddit, BetterReddit.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "better_reddit_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

# General application configuration
config :better_reddit,
  ecto_repos: [BetterReddit.Repo]

# Configures the endpoint
config :better_reddit, BetterReddit.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9cewwyAcCIFBrzgxRspEKvXdBKt6/w1/vMOh8A+A0P6Kgy+yYAgnJu41CPHz8m1o",
  render_errors: [view: BetterReddit.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BetterReddit.PubSub,
           adapter: Phoenix.PubSub.PG2],
  http: [compress: true],
  use_caching: true

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
