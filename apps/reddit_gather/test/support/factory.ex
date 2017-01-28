defmodule RedditGather.Factory do
  use ExMachina

  def api_listing_factory do
    %{
      "data" => %{
        "children" => build_list(25, :api_post)
      }
    }
  end

  def api_post_factory do
    %{
      "data" => %{
        "ups" => 9001,
        "downs" => 1337,
        "title" => sequence("title"),
        "id" => sequence("reddit_id"),
        "over_18" => false,
        "created_utc" => Timex.now() |> Timex.to_unix(),
        "url" => sequence("url"),
        "author" => sequence("author"),
        "subreddit" => sequence("subreddit"),
        "thumbnail_url" => sequence("thumbnail_url")
      }
    }
  end

  def with_posts(listing, children) do
    new_data = Map.put(listing["data"], "children", children)
    Map.put(listing, "data", new_data)
  end

  def with_property(post, key, value) do
    new_data = Map.put(post["data"], key, value)
    Map.put(post, "data", new_data)
  end
end