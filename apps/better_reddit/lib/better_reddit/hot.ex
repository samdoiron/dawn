alias Experimental.GenStage

defmodule BetterReddit.Hot do
  alias BetterReddit.{RedditPostGateway, Schemas, Repo, Broadcaster}
  use GenStage
  require Logger

  @top_post_count 25

  def start_link(name) do
    GenStage.start_link(__MODULE__, [], name: name)
  end
  
  def init(name) do
    opts = [max_demand: 50, name: name]
    state = %{ broadcaster: Broadcaster.new(), cache: %{} }
    {:consumer, state, subscribe_to: [{RedditPostGateway, opts}]}
  end
  
  def add_subscriber(hot_pid, subscriber) do
    GenServer.call(hot_pid, {:add_subscriber, subscriber})
  end

  def in_community(hot_pid, community) do
    GenServer.call(hot_pid, {:in_community, community})
  end

  def handle_call({:add_subscriber, subscriber}, _from, state) do
    new_state = Dict.update!(state, :broadcaster, fn broad ->
      Broadcaster.add_subscriber(broad, subscriber)
    end)
    IO.inspect(new_state)
    {:reply, :ok, [], new_state}
  end

  def handle_call({:in_community, community}, _from, state) do
    cache = ensure_cached(state.cache, community)
    {:reply, cache[community], [], %{ state | cache: cache }}
  end

  def handle_events(reddit_posts, _from, old_state) do
    converted = Enum.map(reddit_posts, &convert_to_post/1)

    # Need to persist first so we get their IDs
    persisted = persist(converted)
    grouped_posts = by_community(persisted)
    new_state = %{ old_state | cache: update_cache(old_state, grouped_posts) }
    update_subscribers(new_state, grouped_posts)
    {:noreply, [], new_state}
  end

  defp update_cache(old_state, grouped_posts) do
    Enum.reduce(grouped_posts, old_state.cache, &update_community_cache/2)
  end

  defp update_community_cache({name, new_posts}, cache) do
    ensured = ensure_cached(cache, name)
    new_top = ensured[name]
    |> difference_by_id(new_posts)
    |> Enum.concat(new_posts)
    |> Enum.sort_by(&(&1.score), &>=/2)
    |> Enum.take(@top_post_count)
    %{ ensured | name => new_top }
  end

  defp difference_by_id(old_posts, new_posts) do
    Enum.filter(old_posts, fn old ->
      Enum.find(new_posts, &(&1.id == old.id)) == nil
    end)
  end

  defp ensure_cached(cache, community) do
    if Map.has_key?(cache, community) do
      cache
    else
      Dict.put(cache, community, fetch_hot(community))
    end
  end
  
  defp persist(posts) do
    {:ok, inserted} = posts
    |> List.foldl(Ecto.Multi.new(), &upsert_post/2)
    |> Repo.transaction()
    Dict.values(inserted)
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
  
  defp update_subscribers(state, grouped_posts) do
    for community <- Dict.keys(grouped_posts) do
      message = {community, state.cache[community]}
      Broadcaster.broadcast(state.broadcaster, message)
    end
  end

  defp by_community(posts) do
    Enum.group_by(posts, &(&1.community), &(&1))
  end

  def fetch_hot(community) do
    Schemas.Post.hot_in_community(community)
  end
end