defmodule BetterReddit.API.CommunityController do
  use BetterReddit.Web, :controller
  alias BetterReddit.Community

  def show(conn, %{ "id" => community_name }) do
    render(conn, "show.json", community: Community.hot(community_name))
  end
end
