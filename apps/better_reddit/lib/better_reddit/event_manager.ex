defmodule BetterReddit.EventManager do
  use GenServer

  @timeout 30_000

  def init(_opts) do
    {:ok, %{handlers: []}}
  end

  def notify(manager, msg) do
   GenServer.call(manager, {:notify, msg})
  end

  def add_handler(manager, handler) do
    GenServer.call(manager, {:add_handler, handler})
  end

  def handle_call({:notify, msg}, _from, %{ handlers: handlers }) do
    for pid <- handlers do
      GenServer.cast(pid, msg)
    end
    :ok
  end

  def handle_call({:add_handler, handler}, _from, state) do
    {:ok, %{ state | handlers: [handler | state.handlers]}}
  end
end