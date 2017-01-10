defmodule BetterReddit.HotChannel do
  use Phoenix.Channel

  def join("hot:" <> _community, _params, socket) do
    {:ok, socket}
  end
end