defmodule StubSubscriber do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:ok, []}
  end

  def received(subscriber) do
    Enum.reverse(GenServer.call(subscriber, :received))
  end

  def handle_cast({:message, message}, messages) do
    {:noreply, [ message | messages ]}
  end

  def handle_call(:received, _from, received) do
    {:reply, received, received}
  end
end

defmodule BetterReddit.BroadcasterTest do
  use ExUnit.Case, async: true
  alias BetterReddit.Broadcaster
  
  test "it can be created" do
    assert Broadcaster.new()
  end

  test "it can broadcast to nobody" do
    Broadcaster.new()
    |> Broadcaster.broadcast("hello")
  end

  test "it can broadcast to a single recipient" do
    {:ok, subscriber}  = StubSubscriber.start_link()

    Broadcaster.new()
    |> Broadcaster.add_subscriber(subscriber)
    |> Broadcaster.broadcast("hello")
    
    assert ["hello"] == StubSubscriber.received(subscriber)
  end

  test "it can broadcast to multiple recipients" do
    {:ok, one} = StubSubscriber.start_link()
    {:ok, two} = StubSubscriber.start_link()
   
    Broadcaster.new()
    |> Broadcaster.add_subscriber(one)
    |> Broadcaster.add_subscriber(two)
    |> Broadcaster.broadcast("hello")

    assert ["hello"] == StubSubscriber.received(one)
    assert ["hello"] == StubSubscriber.received(one)
  end

  test "it can broadcast multiple messages" do
    {:ok, sub} = StubSubscriber.start_link()

    Broadcaster.new()
    |> Broadcaster.add_subscriber(sub)
    |> Broadcaster.broadcast("one")
    |> Broadcaster.broadcast("two")
    
    assert_orderless(["one", "two"], StubSubscriber.received(sub))
  end

  test "messages are delivered in send order" do
    {:ok, sub} = StubSubscriber.start_link()

    Broadcaster.new()
    |> Broadcaster.add_subscriber(sub)
    |> Broadcaster.broadcast("first")
    |> Broadcaster.broadcast("second")

    assert ["first", "second"] == StubSubscriber.received(sub)
  end

  defp assert_orderless(one, two) do
    assert Enum.sort(one) == Enum.sort(two)
  end
end