defmodule BetterReddit.Schemas.Post do
  @moduledoc ~S"""
  A single post, which could come from many different sources
  """
  use Ecto.Schema
  import Ecto.Query
  alias BetterReddit.Repo
  alias BetterReddit.Schemas.Post

  @post_return_count 30


  @primary_key false
  schema "post" do
    field :source_id, :string
    field :title, :string
    field :source, :string
    field :url, :string
    field :author, :string
    field :topic, :string
    field :thumbnail, :string
    field :score, :integer
    field :is_nsfw, :boolean
    field :time_posted, Timex.Ecto.DateTime
  end

  def hot_posts_in_community(community) do
    hot_in_community(community)
    |> where([p], not(is_nil(p.thumbnail)))
    |> Repo.all()
  end

  def hot_discussions_in_community(community) do
    hot_in_community(community)
    |> where([p], is_nil(p.thumbnail))
    |> Repo.all()
  end

  def order_by_hotness(multi) do
    # Hot sorting: Score with a halflife of 5 hours
    multi
    |> order_by([u], desc:
    fragment("power(2.71828, -1 * (1.0/5) * least(24 * 30, greatest(0, extract(epoch from now() - ?) / 3600))) * ?", u.time_posted, u.score))
  end

  def get_by_source_and_id(source, id) do
    post = Post
    |> where([u], u.source == ^source)
    |> where([u], u.source_id == ^id)
    |> Repo.one()

    if post do
      {:ok, post}
    else
      :no_such_post
    end
  end

  defp hot_in_community(community) do
    Post
    |> where([u], u.topic == ^String.downcase(community))
    |> where([u], u.time_posted > ago(1, "day"))
    |> order_by_hotness()
    |> limit(@post_return_count)
  end
end
