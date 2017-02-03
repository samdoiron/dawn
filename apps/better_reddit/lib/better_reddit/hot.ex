alias Experimental.GenStage

defmodule BetterReddit.Hot do
  alias BetterReddit.{RedditPostGateway, Schemas, Repo}
  use GenStage
  require Logger

  @top_post_count 25

  def start_link(name) do
    GenStage.start_link(__MODULE__, :ok, name: name)
  end

  def init(:ok) do
    state = %{cache: %{}}
    {:producer_consumer, state}
  end

  def in_community(hot_pid, community) do
    IO.puts("in in_communtity")
    GenServer.call(hot_pid, {:in_community, community})
  end

  def handle_call({:in_community, community}, _from, state) do
    IO.puts("in in_communtity handle")
    cache = ensure_cached(state.cache, community)
    {:reply, cache[community], [], %{ state | cache: cache }}
  end

  def handle_events(posts, _from, old_state) do
    grouped_posts = by_community(posts)
    new_state = %{old_state | cache: update_cache(old_state, grouped_posts)}
    messages = changed_hot(new_state.cache, Map.keys(grouped_posts))
    {:noreply, messages, new_state}
  end

  defp update_cache(old_state, grouped_posts) do
    Enum.reduce(grouped_posts, old_state.cache, &update_community_cache/2)
  end

  defp update_community_cache({name, new_posts}, cache) do
    ensured = ensure_cached(cache, name)
    new_top = ensured[name]
    |> difference_by_id(new_posts)
    |> Enum.concat(new_posts)
    |> Enum.sort_by(&hotness/1, &>=/2)
    |> Enum.take(@top_post_count)
    %{ ensured | name => new_top }
  end

  defp hotness(post) do
    # Score with a halflife of 4 hours
    e = 2.71827
    hours_ago = Timex.diff(Timex.now(), post.time_posted, :hours)
    scale = :math.pow(e, (-1/4) * hours_ago)
    post.score * scale
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
      Map.put(cache, community, fetch_hot(community))
    end
  end
  
  defp persist(posts) do
    {:ok, inserted} = posts
    |> List.foldl(Ecto.Multi.new(), &upsert_post/2)
    |> Repo.transaction()
    Map.values(inserted)
  end

  defp upsert_post(post, multi) do
    Schemas.Post.upsert_post(multi, post)
  end

  defp by_community(posts) do
    Enum.group_by(posts, &(&1.community), &(&1))
  end

  def fetch_hot(community) do
    Schemas.Post.hot_in_community(community)
  end

  def changed_hot(cache, communities) do
    Enum.map(communities, fn community ->
      {community, cache[community]}
    end)
  end
end