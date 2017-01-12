defmodule BetterReddit.AppController do
  use BetterReddit.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
