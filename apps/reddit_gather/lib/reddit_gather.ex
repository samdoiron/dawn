defmodule RedditGather do
  use Application
  alias RedditGather.HTTP

  @moduledoc ~S"""
  Gathers posts from reddit, and outputs them to the configured post output.

  It is possible that different versions of the same post will be sent at
  different times. In this case, the most recently sent post is the most
  up to date.
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(RedditGather.GatherTop, [&HTTP.fetch/1]),
    ]

    opts = [strategy: :one_for_one, name: RedditGather.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

