alias Experimental.GenStage

defmodule BetterReddit.Hot do
  alias BetterReddit.{RedditPostGateway, Schemas, Repo, Broadcaster}
  use GenStage
  require Logger

  def start_link(name) do
    GenStage.start_link(__MODULE__, [], name: name)
  end
  
  def init(name) do
    opts = [max_demand: 50, name: name]
    state = [broadcaster: Broadcaster.new()]
    {:consumer, state, subscribe_to: [{RedditPostGateway, opts}]}
  end
  
  def add_subscriber(hot_pid, subscriber) do
    GenServer.call(hot_pid, {:add_subscriber, subscriber})
  end

  def handle_call({:add_subscriber, subscriber}, _from, state) do
    new_state = Dict.update!(state, :broadcaster, fn broad ->
      Broadcaster.add_subscriber(broad, subscriber)
    end)
    {:reply, :ok, new_state}
  end

  def handle_events(reddit_posts, _from, state) do
    converted = Enum.map(reddit_posts, &convert_to_post/1)
    persist(converted)
    update_subscribers(state, converted)
    {:noreply, [], state}
  end
  
  defp persist(posts) do
    posts
    |> List.foldl(Ecto.Multi.new(), &upsert_post/2)
    |> Repo.transaction()
  end

  defp upsert_post(post, multi) do
    Schemas.Post.upsert_post(multi, post)
  end

  defp convert_to_post(post) do
    %Schemas.Post {
      original_id: post.reddit_id,
      title: post.title,
      source: "reddit",
      url: post.url,
      author: post.author,
      community: String.downcase(post.subreddit),
      thumbnail: post.thumbnail_url,
      score: post.ups - post.downs,
      is_nsfw: post.is_nsfw,
      time_posted: post.time_posted
    }
  end
  
  defp update_subscribers(state, posts) do
    communities = updated_communities(posts)

    for community <- communities do
      Logger.info("Broadcasting hot in community #{community}")
      Broadcaster.broadcast(state[:broadcaster], fetch_community(community))
    end
  end

  defp updated_communities(posts) do
    posts
    |> Enum.map(& &1.community)
    |> Enum.uniq()
  end

  defp fetch_community(community) do
    Schemas.Post.hot_in_community(community)
  end
end