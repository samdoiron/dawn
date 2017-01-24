defmodule RedditGather.Post do
  @moduledoc ~S"""
  A reddit post, as parsed from the reddit API.
  """

  @derive [Poison.Encoder]
  defstruct ups: 0, downs: 0, reddit_id: "", title: "",
    author: "", subreddit: "", is_nsfw: false, time_posted: Timex.now(),
    url: "", thumbnail_url: ""
end
