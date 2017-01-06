defmodule BetterReddit.API.CommunityView do
  alias BetterReddit.Post
  
  def render("show.json", %{ community: community }) do
    %{
      :name => community.name,
      :posts => Enum.map(community.posts, &format_post/1),
      :discussions => Enum.map(community.discussions, &format_discussion/1)
    }
  end

  def format_post(post) do
    %{
      :id => Post.get_id(post),
      :title => post.title,
      :url => post.url,
      :thumbnail => post.thumbnail,
      :is_nsfw => post.is_nsfw,
      :score => post.score
    }
  end

  def format_discussion(discussion) do
    %{
      :id => Post.get_id(discussion),
      :title => discussion.title,
      :url => discussion.url,
      :is_nsfw => discussion.is_nsfw,
      :score => discussion.score
    }
  end
end
