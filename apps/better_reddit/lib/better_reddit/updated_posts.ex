alias Experimental.GenStage

defmodule BetterReddit.UpdatedPosts do
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
    case Schemas.Post.update_all(posts) do
      {:ok, updated} ->
        {:noreply, updated, state}
      {:error, err} ->
        Logger.error("Failed to update posts: #{err}")
        {:noreply, [], state}
    end
  end
end