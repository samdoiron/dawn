defmodule RedditGather.ClientTest do
  use ExUnit.Case, async: true
  alias RedditGather.{Client, TestFetch, TestFetch}

  test "get_subreddit requests the subreddit's hot 1.0 api" do
    Client.get_subreddit(&TestFetch.recording/1, "programming")
    assert_received "https://www.reddit.com/r/programming.json?raw_json=1"
  end

  test "get_front_page retrieves the hot listing for all" do
    Client.get_front_page(&TestFetch.recording/1)
    assert_received "https://www.reddit.com/r/all.json?raw_json=1"
  end

  test "error results are returned directly" do
    result = Client.get_subreddit(&TestFetch.broken/1, "programming")
    assert {:error, :broken_fetcher_error} == result
  end
end