defmodule BetterReddit.Subreddit do
  defstruct subscribers: 0, name: "", nsfw: false
end

defmodule BetterReddit.GatherSubreddits do
  @timeout_ms 500

  def main do
    run() |> Poison.encode!() |> IO.puts()
  end

  def run(page \\ 1) do
    Application.ensure_all_started(:httpoison)

    subs = api_response(page)
    |> Floki.parse()
    |> extract_subreddits()

    if Enum.count(subs) != 0 do
      :timer.sleep(@timeout_ms)
      subs ++ run(page + 1)
    else
      subs ++ [front_page()]
    end
  end

  defp api_response(page) do
    case HTTPoison.get("http://redditlist.com/all?page=#{page}") do
      {:ok, content} -> content.body
      {:error, err} -> raise err
    end
  end

  defp extract_subreddits(api_data) do
    api_data
    |> Floki.find(".listing")
    |> Enum.at(1)
    |> Floki.find(".listing-item")
    |> Enum.map(&extract_subreddit/1)
  end

  defp extract_subreddit(data) do
    nsfw = Floki.attribute(data, "data-target-filter") |> Enum.at(0) != "sfw"
    name = Floki.attribute(data, "data-target-subreddit") |> Enum.at(0)
    {subscribers, ""} = Floki.find(data, ".listing-stat")
    |> Floki.text()
    |> String.replace(",", "")
    |> Integer.parse()

    %BetterReddit.Subreddit {
      nsfw: nsfw,
      subscribers: subscribers,
      name: name
    }
  end

  defp front_page() do
    %BetterReddit.Subreddit{name: "All", subscribers: 10_000_000, nsfw: false}
  end
end

BetterReddit.GatherSubreddits.main()
