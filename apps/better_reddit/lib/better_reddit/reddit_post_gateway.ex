alias Experimental.GenStage

defmodule BetterReddit.RedditPostGateway do
  @moduledoc ~S"""
  Receives reddit posts from Kafka and broadcasts them too all interested
  parties within the application.

  Most of these subscribers (all as of writing) are Kappa views into the
  database.

  See PostSupevisor for subscription information
  """
  
  defmodule RedditPost do
    defstruct ups: 0, downs: 0, reddit_id: "", title: "",
      author: "", subreddit: "", is_nsfw: false, time_posted: Timex.now(),
      url: "", thumbnail_url: ""
  end
  
  @kafka_topic "reddit_post"

  use GenStage
  require Logger

  def start_link(name) do
    GenStage.start_link(__MODULE__, [], name: name)
  end

  def init([]) do
    {:producer, [], dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_demand(demand, state) when demand > 0 do
    {:noreply, receive_posts(state, demand), state}
  end

  defp receive_posts(state, demand) do
    if demand <= 0 do
      []
    else
      chunk = receive_chunk()
      chunk ++ receive_posts(state, demand - length(chunk))
    end
  end

  defp receive_chunk do
    case KafkaEx.fetch(@kafka_topic, 0) do
      :topic_not_found ->
        raise "Invalid topic: \"#{@kafka_topic}\""

      responses ->
        posts = responses
        |> Enum.map(&process_response/1)
        |> List.flatten()
        posts
    end
  end

  defp process_response(response) do
    # Only one partition currently
    partition_response = List.first(response.partitions)
    parse_messages(partition_response.message_set)
  end

  defp parse_messages(message_set) do
    message_set
    |> Enum.map(fn message ->
      decoded = Poison.decode!(message.value, as: %RedditPost{})
      {:ok, parsed_time} = Timex.parse(decoded.time_posted, "{ISO:Extended}")
      %{decoded | time_posted: parsed_time}
    end)
  end
end
