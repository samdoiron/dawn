defmodule BetterReddit.Post do
  alias BetterReddit.Schemas
  alias BetterReddit.Cache

  use GenServer

  def start_link(opts) do
    Cache.start_link(:hot_posts_cache)
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init([posts_cache: posts,
            hot_discussions_cache: hot_discussions,
            hot_posts_cache: hot_posts]) do

    {:ok, %{hot_posts: hot_posts,
            hot_discussions: hot_discussions,
            posts: posts}}
  end

  def get_id(post), do: "#{post.source}-#{post.source_id}"

  def get_by_id(composite_id) do
    case split_id(composite_id) do
      [source, id] ->
        GenServer.call(__MODULE__, {:get_by_source_and_id, source, id})
      _ -> :no_such_post
    end
  end

  def hot_posts_in_community(community_name) do
    GenServer.call(__MODULE__, {:hot_posts_in_community, community_name})
  end

  def hot_discussions_in_community(community_name) do
    GenServer.call(__MODULE__, {:hot_discussions_in_community, community_name})
  end

  defp split_id(composite_id) do
    String.split(composite_id, "-")
  end

  def handle_call({:get_by_source_and_id, source, id}, _from, state) do
    fetched_post = Cache.get_or_calculate(state.posts, id, fn ->
      Schemas.Post.get_by_source_and_id(source, id)
    end)

    {:reply, fetched_post, state}
  end

  def handle_call({:hot_posts_in_community, community_name}, _from, state) do
    posts = Cache.get_or_calculate(state.hot_posts, community_name, fn ->
      Schemas.Post.hot_posts_in_community(community_name)
    end)
    cache_posts(state.posts, posts)
    {:reply, posts, state}
  end

  def handle_call({:hot_discussions_in_community, community_name}, _from, state) do
    posts = Cache.get_or_calculate(state.hot_discussions, community_name, fn ->
      Schemas.Post.hot_discussions_in_community(community_name)
    end)
    cache_posts(state.posts, posts)
    {:reply, posts, state}
  end

  defp cache_posts(cache, posts) do
    Enum.each(posts, fn post -> cache_post(cache, post) end)
  end

  defp cache_post(cache, post) do
    Cache.set(cache, get_id(post), post)
  end
end
