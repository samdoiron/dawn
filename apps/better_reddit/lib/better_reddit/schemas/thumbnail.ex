defmodule BetterReddit.Schemas.Thumbnail do
  alias BetterReddit.Schemas
  alias BetterReddit.Repo
  use Ecto.Schema
  import Ecto.Changeset

  @thumbnail_directory "thumbnails"

  schema "thumbnail" do
    belongs_to :reddit_post, Schemas.RedditPost, type: :string
    field :source_url, :string, length: 2048, null: false
    field :file_name, :string
    field :content_type, :string
  end

  def download_and_insert_for(post) do
    url = post.thumbnail_url
    with {:ok, image, content_type} <- download(post, url),
         file_extension <- content_type_to_extension(content_type),
         {:ok, file_name} <- store(image, file_extension)
         do
           {:ok, Repo.insert!(%Schemas.Thumbnail{
                   reddit_post_id: post.reddit_id,
                   source_url: url,
                   file_name: file_name,
                   content_type: content_type
                 })}
         end
  end

  defp download(post, url) do
    case HTTPoison.get(url) do
      {:ok, response} ->
        case validate_response(response) do
          {:ok, file_name} -> {:ok, file_name}
          {:error, :removed} ->
            remove_thumbnail(post)
            {:error, :removed}
          other -> other
        end
      other -> other
    end
  end

  defp remove_thumbnail(post) do
    post
    |> change(thumbnail_url: nil)
    |> Repo.update()
  end

  defp store(image, extension) do
    file_name = make_file_name(image, extension)
    with {:ok, file} <- open_thumbnail_file(file_name),
         :ok <- IO.binwrite(file, image),
         :ok <- File.close(file),
         do: {:ok, file_name}
  end
  
  defp validate_response(response) do
    headers = response.headers
    |> normalize_header_names()
    |> Enum.into(%{})

    content_type = headers["content-type"]
    cond do
      image_content_type?(content_type) ->
        {:ok, response.body, headers["content-type"]}
      is_404?(response) -> {:error, :removed}
      true -> {:error, :not_an_image, response.body}
    end
  end

  defp is_404?(response), do: response.status_code == 404

  defp image_content_type?(content_type) do
    if content_type == nil do
      false
    else
      String.starts_with?(content_type, "image/")
    end
  end

  defp normalize_header_names(headers) do
    for {name, value} <- headers do
      {String.downcase(name), value}
    end
  end

  defp open_thumbnail_file(file_name) do
    Path.join([@thumbnail_directory, file_name])
    |> File.open([:write, :binary])
  end

  defp make_file_name(image, extension) do
    file_name = :crypto.hash(:md5, image)
                |> Base.encode32(padding: false, case: :lower)
    "#{file_name}.#{extension}"
  end

  defp content_type_to_extension(content_type) do
    String.split(content_type, "/") |> Enum.at(1)
  end
end
