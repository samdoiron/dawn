use Mix.Config

config :reddit_gather,
  post_output: RedditGather.MockPostOutput,
  time: RedditGather.TestTime
