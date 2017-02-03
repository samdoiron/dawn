alias Experimental.GenStage

defmodule BetterReddit.HotChannelConsumer do
  alias BetterReddit.HotChannel
  use GenStage

  def start_link(name) do
    GenStage.start_link(__MODULE__, :ok, name: name)
  end

  def init(:ok) do
    {:consumer, :ok}
  end

  def handle_events(events, _from, state) do
    Enum.each(events, &HotChannel.hot_update/1)
    {:noreply, [], state}
  end
end