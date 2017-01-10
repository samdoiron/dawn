alias Experimental.GenStage

defmodule BetterReddit.RedditPostSupervisor do
  alias BetterReddit.{Hot, RedditPostGateway}

  def start_link do
    import Supervisor.Spec

    # BUG: Possibly dropping some posts because we don't buffer messages
    # before subscribers have started.
    children = [
      worker(RedditPostGateway, [RedditPostGateway]),
      worker(Hot, [Hot])
    ]

    {:ok, sup} = Supervisor.start_link(children, [strategy: :one_for_all])

    {:ok, sup}
  end
end