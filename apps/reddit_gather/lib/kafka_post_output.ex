defmodule RedditGather.KafkaPostOutput do
  @behaviour RedditGather.PostOutput

  def send(post) do
    encoded = Poison.encode!(post)
    KafkaEx.produce("reddit_post", 0, encoded)
  end
end