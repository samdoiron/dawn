use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :better_reddit, BetterReddit.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :cache,
  enabled: false

# Configure your database
config :better_reddit, BetterReddit.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "better_reddit_test",
  password: "pass",
  database: "better_reddit_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
