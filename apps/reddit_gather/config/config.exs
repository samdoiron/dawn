use Mix.Config

config :kafka_ex,
  brokers: [
    {"localhost", 9092}
  ],
  consumer_group: "reddit_gather",
  use_ssl: false

import_config "#{Mix.env}.exs"
