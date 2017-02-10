alias Experimental.GenStage

defmodule BetterReddit.PostSupervisor do
  alias BetterReddit.{Hot, RedditPostGateway, ConvertRedditPosts, SplitPosts,
                      NewPosts, UpdatedPosts, HotChannelConsumer}

  def start_link do
    import Supervisor.Spec

    # BUG: Possibly dropping some posts because we don't buffer messages
    # before subscribers have started.
    children = [
      worker(RedditPostGateway, [RedditPostGateway]),
      worker(ConvertRedditPosts, [ConvertRedditPosts]),
      worker(SplitPosts, [SplitPosts]),
      worker(NewPosts, [NewPosts]),
      worker(UpdatedPosts, [UpdatedPosts]),
      worker(Hot, [Hot]),
      worker(HotChannelConsumer, [HotChannelConsumer])
    ]

    {:ok, pid} = Supervisor.start_link(children, [strategy: :one_for_all])

    # Gateway -> Post conversion
    GenStage.sync_subscribe(ConvertRedditPosts, to: RedditPostGateway, max_demand: 50)

    # Posts -> New / Old partition
    GenStage.sync_subscribe(SplitPosts, to: ConvertRedditPosts, max_demand: 50)

    # New / Old (:new) -> New post processing
    GenStage.sync_subscribe(NewPosts, to: SplitPosts, partition: :new)

    # New / old (:old) -> Updated post processing
    GenStage.sync_subscribe(UpdatedPosts, to: SplitPosts, partition: :old)

    #  New / Updated -> Hot kappa view
    GenStage.sync_subscribe(Hot, to: UpdatedPosts)
    GenStage.sync_subscribe(Hot, to: NewPosts)

    # Hot kappa view -> Hot websocket channel
    GenStage.sync_subscribe(HotChannelConsumer, to: Hot)
    {:ok, pid}
  end

  defp hot_topic({community, _}), do: "hot:" <> community

  def hot_event(_), do: "update"
end
