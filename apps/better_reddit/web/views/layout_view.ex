defmodule BetterReddit.LayoutView do
  use BetterReddit.Web, :view

  def site_css, do: try_read_static_file("css/app.css")
  def site_js, do: try_read_static_file("js/app.js")

  def try_read_static_file(name) do
    case File.read("priv/static/#{name}") do
      {:ok, css} -> css
      {:err, _} -> ""
    end
  end
end
