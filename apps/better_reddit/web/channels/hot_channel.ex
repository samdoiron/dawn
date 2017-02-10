defmodule BetterReddit.HotChannel do
  use Phoenix.Channel
  alias BetterReddit.{Endpoint, Hot}
  require Logger

  def hot_update({community, posts}) do
    Logger.debug("broadasting hot update to #{community}")
    formatted = reformat_posts(posts, community)
    Endpoint.broadcast!("hot:#{community}", "update", formatted)
  end

  def join("hot:" <> community, _params, socket) do
    send(self, {:after_join, community})
    {:ok, socket}
  end
  
  def handle_info({:after_join, community}, socket) do
    push socket, "update", hot_in_community(community)
    {:noreply, socket}
  end

  defp hot_in_community(community) do
    Hot.in_community(Hot, community)
    |> reformat_posts(community)
  end

  defp reformat_posts(posts, community) do
    posts
    |> Enum.map(&remove_ecto_magic/1)
    |> posts_update_message(community)
  end

  defp remove_ecto_magic(post) do
    post
    |> Map.delete(:"__struct__")
    |> Map.delete(:"__meta__")
  end

  defp posts_update_message(posts, community) do
    %{
      name: community,
      posts: posts,
      discussions: []
    }
  end
end
