defmodule BetterReddit.Plugs.MinifyHTML do
  import Plug.Conn
  alias BetterReddit.HTML

  def init(default), do: default

  def call(conn, _default) do
    register_before_send conn, fn conn ->
      body = to_string(conn.resp_body)
      resp(conn, conn.status, body |> HTML.minify())
    end
  end
end