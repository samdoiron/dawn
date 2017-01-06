defmodule BetterReddit.Reddit.Gather do
  @moduledoc ~S"""
  Gatherer is the constant process that gathers content fron Reddit's
  API and stores it in the database.
  """

  alias BetterReddit.Schedule
  alias BetterReddit.Reddit
  require Logger

  @max_priority 500_000
  @reddit_api_timeout_ms 2_000

  def start_link do
    case Task.start_link(fn -> run(load_priorities()) end) do
      {:ok, pid} -> process_started(pid)
      other -> other
    end
  end

  defp process_started(pid) do
    Process.register(pid, __MODULE__)
    {:ok, pid}
  end

  def run(priorities) do
    priorities
    |> Schedule.with_priorities()
    |> Enum.each(&update_subreddit/1)
  end

  defp update_subreddit(name) do
    sleep_timeout()
    Logger.info("updating subreddit #{name}")
    case Reddit.HTTP.get_subreddit(name) do
      {:ok, posts} -> Reddit.PostProcessor.process(posts)
      {:error, err} -> Logger.warn("failed to fetch subreddit #{inspect(err)}")
    end
  end

  defp sleep_timeout do
    :timer.sleep(@reddit_api_timeout_ms)
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