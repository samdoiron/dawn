defmodule BetterReddit.PostSupervisor do
  alias BetterReddit.Cache
  alias BetterReddit.Post

  def start_link do
    import Supervisor.Spec

    children = [
      worker(Cache, [:posts_cache], id: :posts_cache),
      worker(Cache, [:hot_discussions_cache], id: :hot_discussions_cache),
      worker(Cache, [:hot_posts_cache], id: :hot_posts_cache),
      worker(Post, [[
        posts_cache: :posts_cache,
        hot_discussions_cache: :hot_discussions_cache,
        hot_posts_cache: :hot_posts_cache
      ]])
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end