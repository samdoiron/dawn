defmodule BetterReddit.ListingParserTest do
  use ExUnit.Case, async: true

  alias RedditGather.ListingParser
  alias RedditGather.Post

  setup do
    listing = File.read!("test/data/reddit_hot.json")
    {:ok, listing: listing}
  end

  test "parse has correct number of posts", %{listing: listing} do
    {:ok, parsed} = ListingParser.parse(listing)
    assert 25 == Enum.count(parsed)
  end

  test "parse has no empty titles", %{listing: listing} do
    {:ok, posts} = ListingParser.parse(listing)
    Enum.each(posts, fn (post) ->
      assert nil != post.title
      assert "" != post.title
    end)
  end

  test "parse entries have a url", %{listing: listing} do
    {:ok, posts} = ListingParser.parse(listing)
    Enum.each(posts, fn (post) ->
      assert nil != post.url
      assert "" != post.url
    end)
  end

  test "parse entries have an author", %{listing: listing} do
    {:ok, posts} = ListingParser.parse(listing)
    Enum.each(posts, fn (post) ->
      assert nil != post.author
      assert "" != post.author
    end)
  end

  defp create_listing(posts) do
    Poison.encode!(%{
      "data" => %{
        "children" => Enum.map(posts, fn (post) ->
          %{ "data" => create_post_response(post) }
        end)
      }
    })
  end

  defp create_post_response(post) do
    %{
      "title" => post.title,
      "ups" => post.ups,
      "downs" => post.downs,
      "url" => post.url,
      "author" => post.author,
      "subreddit" => post.subreddit,
      "created_utc" => Timex.to_unix(post.time_posted)
    }
  end

  defp basic_post do
    %Post{
      title: "",
      url: "",
      time_posted: DateTime.from_unix!(0)
    }
  end
end
