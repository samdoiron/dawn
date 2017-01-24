use Mix.Config

config :reddit_gather,
  post_output: RedditGather.KafkaPostOutput,
  time: RedditGather.ActualTime

config :kafka_ex,
  brokers: [
    {"localhost", 9092}
  ],
  consumer_group: "reddit_gather",
  use_ssl: false