alias Experimental.GenStage

defmodule BetterReddit.ConvertRedditPosts do
  alias BetterReddit.Schemas
  use GenStage

  def start_link(name) do
    GenStage.start_link(__MODULE__, [], name: name)
  end

  def init([]) do
    {:producer_consumer, [], dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_events(events, _from, state) do
    converted = Enum.map(events, &convert_reddit_post/1)
    {:noreply, converted, state}
  end

  defp convert_reddit_post(post) do
    %Schemas.Post{
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
end