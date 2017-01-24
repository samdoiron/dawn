defmodule RedditGather.KafkaPostOutput do
  @behaviour RedditGather.PostOutput

  @moduledoc ~S"""
  Output gathered reddit posts to Kafka, json encoded.

  Posts are sent to the "reddit_post" topic.
  """

  def send(post) do
    encoded = Poison.encode!(post)
    KafkaEx.produce("reddit_post", 0, encoded)
  end
end
