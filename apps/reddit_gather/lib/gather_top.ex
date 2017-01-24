defmodule RedditGather.GatherTop do
  @moduledoc ~S"""
  Gatherer is the constant process that gathers content fron Reddit's
  API and sends it to the configured output.
  """

  alias RedditGather.Schedule
  alias RedditGather.Client

  require Logger

  @time Application.get_env(:reddit_gather, :time)
  @output Application.get_env(:reddit_gather, :post_output)

  @max_priority 500_000
  @reddit_api_timeout_ms 2_000

  def start_link(fetcher) do
    case Task.start_link(fn -> run(fetcher, load_priorities()) end) do
      {:ok, pid} -> process_started(pid)
      other -> other
    end
  end

  defp process_started(pid) do
    Process.register(pid, __MODULE__)
    {:ok, pid}
  end

  defp run(fetcher, priorities) do
    priorities
    |> Schedule.with_priorities()
    |> Enum.each(&(update_subreddit(fetcher, &1)))
  end

  def update_subreddit(fetcher, name) do
    sleep_timeout()
    Logger.info("updating subreddit #{name}")
    case Client.get_subreddit(fetcher, name) do
      {:ok, posts} -> send_posts(posts)
      {:error, err} -> Logger.warn("failed to fetch subreddit #{inspect(err)}")
    end
  end

  defp sleep_timeout do
    @time.sleep_ms(@reddit_api_timeout_ms)
  end

  defp send_posts(posts) do
    Enum.each(posts, &@output.send/1)
  end

  defp load_priorities do
    case File.read("config/subreddits.json") do
      {:ok, content} -> parse_priorities(content)
      {:error, err} -> raise "could not load subreddit list: #{err}"
    end
  end

  defp parse_priorities(content) do
    content
    |> Poison.decode!()
    |> Enum.reduce(%{}, fn (subreddit, priorities) ->
      priority = Enum.min([subreddit["subscribers"], @max_priority])
      Map.put(priorities, subreddit["name"], priority)
    end)
  end
end
