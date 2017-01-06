defmodule RedditGather.ConsolePostOutput do
  @behaviour RedditGather.PostOutput

  require Logger

  def send(post) do
    Logger.info("OUTPUT: #{post.title}")
  end
end