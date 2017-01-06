defmodule BetterReddit.EmbedView do
  use BetterReddit.Web, :view

  @image_extensions ["gif", "jpg", "jpeg", "webp", "png", "bmp"]

  def render_post(post) do
    uri = URI.parse(post.url)

    cond do
      image?(uri) -> render_image(uri)
      gifv?(uri) -> handle_gifv(uri)
      imgur_image?(uri) -> handle_imgur(uri)
      gfycat?(uri) -> handle_gfycat(uri)
      youtube?(uri) -> handle_youtube(uri)
      youtube_short?(uri) -> handle_youtube_short(uri)
      true -> render_default(uri)
    end
  end

  defp image?(uri) do
    extension = uri.path |> String.split(".") |> List.last()
    Enum.member?(@image_extensions, extension)
  end

  defp imgur_image?(uri) do
    is_file = String.match?(uri.path, ~r/^\/[a-zA-Z0-9]+\/?$/)
    imgur?(uri) && is_file
  end

  defp handle_imgur(uri) do
    id = imgur_id(uri)
    render_image(%{ uri | host: "i.imgur.com", path: "/#{id}.png}" })
  end

  defp gifv?(uri) do
    uri.host == "i.imgur.com" && String.match?(uri.path, ~r/[^\/]+\.gifv\/?/)
  end

  defp imgur?(uri) do
    uri.host == "imgur.com" || uri.host == "m.imgur.com"
  end

  defp handle_gifv(uri) do
    id = imgur_id(uri)
    render_video([{"video/mp4", "//i.imgur.com/#{id}.mp4"}])
  end

  def gfycat?(uri) do
    uri.host == "gfycat.com" || uri.host == "www.gfycat.com"
  end

  def handle_gfycat(uri) do
    id = String.split(uri.path, "/") |> Enum.at(1)
    render_iframe(make_https(%{ uri | path: "/ifr/#{id}" }))
  end

  def youtube?(uri) do
    uri.host == "www.youtube.com" && uri.path == "/watch"
  end

  def handle_youtube(uri) do
    params = URI.decode_query(uri.query)
    id = params["v"]
    render_iframe(%{ uri | path: "/embed/#{id}" })
  end

  def youtube_short?(uri), do: uri.host == "youtu.be"

  def handle_youtube_short(uri) do
    id = uri.path |> String.split("/") |> Enum.at(1)
    render_iframe(%URI{ host: "www.youtube.com",
                        path: "/embed/#{id}",
                        query: uri.query})
  end

  defp render_default(uri) do
    render "default.html", url: URI.to_string(uri), host: uri.host
  end

  def render_image(uri) do
    render "image.html", source: URI.to_string(uri)
  end

  defp render_video(sources) do
    render "video.html", sources: sources
  end

  defp render_iframe(source) do
    render "iframe.html", source: URI.to_string(source)
  end

  defp imgur_id(uri) do
    uri.path
    |> String.split("/")
    |> List.last()
    |> String.split(".")
    |> List.first()
  end

  defp make_https(uri) do
    %{ uri | scheme: "https", port: 443 }
  end
end
