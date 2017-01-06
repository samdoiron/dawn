defmodule BetterReddit.Community do
  alias BetterReddit.Community
  alias BetterReddit.Post

  defstruct name: "", posts: [], discussions: []

  def hot(topic) do
    %Community{
      name: topic,
      posts: Post.hot_posts_in_community(topic),
      discussions: Post.hot_discussions_in_community(topic)
    }
  end
end
