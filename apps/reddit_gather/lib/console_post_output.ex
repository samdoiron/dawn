defmodule RedditGather.ConsolePostOutput do
  @behaviour RedditGather.PostOutput
  @moduledoc ~S"""
  Output gathered reddit posts to the console.
  """

  require Logger

  def send(post) do
    Logger.info("OUTPUT: #{post.title}")
  end
end
