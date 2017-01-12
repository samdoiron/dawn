defmodule BetterReddit.Broadcaster do
  def new do
    []
  end

  def broadcast(broad, message) do
    for subscriber <- broad do
      send_individual(broad, subscriber, message)
    end
    broad
  end

  def send_individual(broad, subscriber, message) do
    GenServer.call(subscriber, {:message, message})
    broad
  end

  def add_subscriber(broad, subscriber) do
    [subscriber | broad]
  end
end