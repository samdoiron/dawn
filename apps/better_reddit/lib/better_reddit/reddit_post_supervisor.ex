alias Experimental.GenStage

defmodule BetterReddit.RedditPostSupervisor do
  alias BetterReddit.{Hot, HotChannel, RedditPostGateway, Subscriber}

  def start_link do
    import Supervisor.Spec

    # BUG: Possibly dropping some posts because we don't buffer messages
    # before subscribers have started.
    children = [
      worker(RedditPostGateway, [RedditPostGateway]),
      worker(Hot, [Hot]),
      worker(Subscriber, [HotSubscriber, &HotChannel.hot_update/1])
    ]

    {:ok, pid} = Supervisor.start_link(children, [strategy: :one_for_all])
    Hot.add_subscriber(Hot, HotSubscriber)
    {:ok, pid}
  end

  defp hot_topic({community, _}), do: "hot:" <> community

  def hot_event(_), do: "update"
end