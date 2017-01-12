defmodule BetterReddit.Subscriber do
  use GenServer

  def start_link(name, handler) do
    GenServer.start_link(__MODULE__, handler, name: name)
  end

  def init(handler) do
    {:ok, handler}
  end

  def handle_call({:message, message}, _from, handler) do
    handler.(message)
    {:reply, :ok, handler}
  end
end