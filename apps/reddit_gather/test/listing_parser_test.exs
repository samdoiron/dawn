defmodule RedditGather.ListingParserTest do
  use ExUnit.Case, async: true
  import RedditGather.Factory

  alias RedditGather.ListingParser

  setup do
    listing = File.read!("test/data/reddit_hot.json")
    {:ok, listing: listing}
  end

  test "parse has correct number of posts", %{listing: listing} do
    assert 25 == Enum.count(parse(listing))
  end

  test "parse has no empty titles", %{listing: listing} do
    Enum.each(parse(listing), fn (post) ->
      assert nil != post.title
      assert "" != post.title
    end)
  end

  test "parse entries have a url", %{listing: listing} do
    Enum.each(parse(listing), fn (post) ->
      assert nil != post.url
      assert "" != post.url
    end)
  end

  test "parse entries have an author", %{listing: listing} do
    Enum.each(parse(listing), fn post ->
      assert nil != post.author
      assert "" != post.author
    end)
  end


  test "parse entries time_posted is a DateTime", %{listing: listing} do
    Enum.each(parse(listing), fn post ->
      DateTime.to_string(post.time_posted)
    end)
  end

  test "ups are extracted directly" do
    listing = build(:api_listing)
    assert_transform(children(listing), reparse(listing),
                     fetch("ups"),      &(&1.ups))
  end

  test "downs are extracted directly" do
    listing = build(:api_listing)
    assert_transform(children(listing), reparse(listing),
                     fetch("downs"),    &(&1.downs))
  end

  test "title is extracted directly" do
    listing = build(:api_listing)
    assert_transform(children(listing), reparse(listing),
                     fetch("title"),    &(&1.title))
  end

  test "subreddit is extracted directly" do
    listing = build(:api_listing)
    assert_transform(children(listing),  reparse(listing),
                     fetch("subreddit"), &(&1.subreddit))
  end

  test "url is extracted directly" do
    listing = build(:api_listing)
    assert_transform(children(listing), reparse(listing),
                     fetch("url"),      &(&1.url))
  end
  
  test "is_nsfw is extracted from over_18" do
    listing = build(:api_listing)
    assert_transform(children(listing), reparse(listing),
                     fetch("over_18"),  &(&1.is_nsfw))
  end

  test "special thumbnail values are treated as nil" do
    special_values = ["default", "self", "nsfw", "image", "spoiler", ""]
    special_posts = for value <- special_values do
      build(:api_post) |> with_property("thumbnail", value)
    end
    listing = build(:api_listing) |> with_posts(special_posts)
    Enum.each(reparse(listing), fn post ->
      assert nil == post.thumbnail_url
    end)
  end

  test "created_utc is parsed as the correct time" do
    listing = build(:api_listing)
    |> with_posts([build(:api_post) |> with_property("created_utc", 0)])
    [actual_post] = reparse(listing)
    assert Timex.from_unix(0) == actual_post.time_posted
  end

  defp assert_transform(input, output, from_input, from_output) do
    expected = Enum.map(input, from_input)
    actual = Enum.map(output, from_output)
    assert expected == actual
  end

  defp fetch(property), do: fn post -> post["data"][property] end

  defp parse(listing) do
    {:ok, listing} = ListingParser.parse(listing)
    listing
  end

  defp reparse(listing) do
    {:ok, parsed} = listing
    |> encode_listing()
    |> ListingParser.parse()
    parsed
  end
  
  defp children(listing) do
    listing["data"]["children"]
  end

  defp encode_listing(listing), do: Poison.encode!(listing)
end