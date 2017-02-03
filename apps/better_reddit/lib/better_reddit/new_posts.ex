alias Experimental.GenStage

defmodule BetterReddit.NewPosts do
  alias BetterReddit.Schemas
  use GenStage
  require Logger

  def start_link(name) do
    GenStage.start_link(__MODULE__, :ok, name: name)
  end

  def init(:ok) do
    {:producer_consumer, []}
  end

  def handle_events(posts, _from, state) do
    case Schemas.Post.insert_all(posts) do
      {:ok, inserted} ->
        {:noreply, inserted, state}
      {:error, err} ->
        Logger.error("Failed to insert posts: #{err}")
        {:noreply, [], state}
    end
  end
end