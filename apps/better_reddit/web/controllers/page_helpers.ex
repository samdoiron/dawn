defmodule BetterReddit.PageHelpers do
  import Plug.Conn

  def put_title(conn, title) do
    assign(conn, :page_title, title)
  end
end
