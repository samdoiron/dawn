defmodule RedditGather do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(RedditGather.GatherTop, []),
    ]

    opts = [strategy: :one_for_one, name: RedditGather.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

