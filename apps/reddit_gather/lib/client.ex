defmodule RedditGather.Client do
  @moduledoc ~S"""
  Reddit.HTTP is the HTTP implementation of the Reddit behaviour, which
  delegates to a Fetcher-backed copy of the actual reddit API to perform
  requsts.
  """
  alias RedditGather.ListingParser

  @fetcher RedditGather.HTTPFetcher

  def get_front_page do
    fetch_and_parse_listing("all")
  end

  def get_subreddit(name) do
    fetch_and_parse_listing(subreddit_url(name))
  end

  defp fetch_and_parse_listing(url) do
    case @fetcher.fetch(url) do
      {:ok, listing} -> ListingParser.parse(listing)
      err -> err
    end
  end

  defp subreddit_url(name) do
    "https://www.reddit.com/r/#{name}.json?raw_json=1"
  end
end
