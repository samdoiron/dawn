defmodule RedditGather.ListingParser do
  alias RedditGather.Post

  @moduledoc ~S"""
  Parser parser a Reddit API response, and returns an internal representation
  of the parsed data.
  """

  def parse(listing) do
    {:ok, listing |> Poison.decode!() |> extract_posts()}
  end

  defp extract_posts(json) do
    json
    |> Map.get("data")
    |> Map.get("children")
    |> Enum.map(&parse_post/1)
  end

  defp parse_post(entry) do
    post = Map.get(entry, "data")

    %Post{
      reddit_id: Map.get(post, "id"),
      title: Map.get(post, "title"),
      ups: Map.get(post, "ups"),
      downs: Map.get(post, "downs"),
      url: Map.get(post, "url"),
      author: Map.get(post, "author"),
      subreddit: Map.get(post, "subreddit"),
      is_nsfw: Map.get(post, "over_18"),
      time_posted: extract_time_posted(post),
      thumbnail_url: extract_thumbnail(post)
    }
  end

  defp extract_time_posted(post) do
    post
    |> Map.get("created_utc")
    |> trunc()
    |> DateTime.from_unix!(:seconds)
  end

  defp extract_thumbnail(post) do
    thumbnail = Map.get(post, "thumbnail")
    case thumbnail do
      "default" -> nil
      "self" -> nil
      "nsfw" -> nil
      "image" -> nil
      "spoiler" -> nil
      "" -> nil
      _ -> thumbnail
    end
  end
end
