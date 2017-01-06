defmodule BetterReddit.Cache do
  use GenServer

  def start_link(name, cache_ms \\ 60_000) do
    GenServer.start_link(__MODULE__, [table_name: name,
                                      cache_ms: cache_ms], name: name)
  end

  def get_or_calculate(cache, key, fallback_fn) do
    if cache_disabled? do
      fallback_fn.()
    else
      IO.puts("cache enabled")
      case GenServer.call(cache, {:get, key}) do
        {:found, result} -> result
        :not_found -> set(cache, key, fallback_fn.())
      end
    end
  end

  def set(cache, key, value) do
    GenServer.call(cache, {:set, key, value})
  end

  def handle_call({:get, key}, _from, state) do
    name = state[:table_name]
    case :ets.lookup(name, key) do
      [{_key, value, time_inserted}] ->
        if expired?(state, time_inserted) do
          :ets.delete(name, key)
          {:reply, :not_found, state}
        else
          {:reply, {:found, value}, state}
        end
      _ -> {:reply, :not_found, state}
    end
  end

  def handle_call({:set, key, value}, _from, state) do
    name = state[:table_name]
    true = :ets.insert(name, {key, value, now()})
    {:reply, value, state}
  end

  def init(state) do
    :ets.new(state[:table_name], [:named_table, :set, :private])
    {:ok, state}
  end

  defp expired?(state, time_created) do
    time_created > now() + state[:cache_ms]
  end

  defp cache_disabled? do
    !Application.get_env(:config, :use_caching)
  end

  defp now, do: :os.system_time(:milli_seconds)
end
