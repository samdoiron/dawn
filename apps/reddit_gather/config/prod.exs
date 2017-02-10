use Mix.Config

config :reddit_gather,
  post_output: RedditGather.KafkaPostOutput,
  time: RedditGather.ActualTime
