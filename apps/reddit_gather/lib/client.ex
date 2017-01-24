defmodule RedditGather.Client do
  @moduledoc ~S"""
  RedditGather.Client provides access to the Reddit HTTP API.
  
  It delegates to a Fetcher-backed copy of the actual reddit API to perform
  requests.
  """
  alias RedditGather.ListingParser

  def get_front_page(fetch) do
    get_subreddit(fetch, "all")
  end

  def get_subreddit(fetch, name) do
    fetch_and_parse_listing(fetch, subreddit_url(name))
  end

  defp fetch_and_parse_listing(fetch, url) do
    case fetch.(url) do
      {:ok, listing} -> ListingParser.parse(listing)
      err -> err
    end
  end
  
  defp subreddit_url(name) do
    "https://www.reddit.com/r/#{name}.json?raw_json=1"
  end
end
