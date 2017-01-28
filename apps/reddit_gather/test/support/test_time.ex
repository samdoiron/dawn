defmodule RedditGather.TestTime do
  use GenServer
  @behaviour RedditGather.Time

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, 0}
  end

  def sleep_ms(milliseconds) do
    GenServer.call(__MODULE__, {:sleep_ms, milliseconds})
  end

  def time_passed do
    GenServer.call(__MODULE__, :time_passed)
  end

  def handle_call({:sleep_ms, milliseconds}, _from, time) do
    IO.puts("sleeping for #{milliseconds}")
    {:reply, :ok, time + milliseconds}
  end

  def handle_call(:time_passed, _from, time), do: {:reply, time, time}
end