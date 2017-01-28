defmodule RedditGather.MockPostOutput do
  use GenServer
  @behaviour RedditGather.PostOutput

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, []}
  end

  def send(message) do
    GenServer.call(__MODULE__, {:send, message})
  end

  def sent_posts do
    GenServer.call(__MODULE__, :sent_posts)
  end

  def handle_call({:send, message}, _from, state) do
    {:reply, :ok, [message | state]}
  end

  def handle_call(:sent_posts, _from, state) do
    {:reply, Enum.reverse(state), state}
  end
end