defmodule RedditGather.TestFetch do
  import RedditGather.Factory

  def recording(url) do
    send self(), url
    {:ok, build(:api_listing) |> Poison.encode!()}
  end

  def broken(_url) do
    {:error, :broken_fetcher_error}
  end
end