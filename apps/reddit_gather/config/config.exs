# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :reddit_gather,
  post_output: RedditGather.KafkaPostOutput

config :kafka_ex,
  brokers: [
    {"localhost", 9092}
  ],
  consumer_group: "reddit_gather",
  use_ssl: false