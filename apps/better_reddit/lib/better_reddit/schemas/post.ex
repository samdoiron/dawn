defmodule BetterReddit.Schemas.Post do
  @moduledoc ~S"""
  A single post, which could come from many different sources
  """
  use Ecto.Schema
  import Ecto.Query
  alias BetterReddit.Repo
  alias BetterReddit.Schemas.Post
  alias Ecto.Multi

  @default_count 30
  schema "post" do
    field :original_id, :string, null: false
    field :title, :string
    field :source, :string
    field :url, :string
    field :author, :string
    field :community, :string
    field :thumbnail, :string
    field :score, :integer
    field :is_nsfw, :boolean
    field :time_posted, :utc_datetime
  end

  def upsert_post(multi, post) do
    update_properties = [
      set: [
        score: post.score,
        thumbnail: post.thumbnail,
        is_nsfw: post.is_nsfw,
      ]
    ]

    Multi.insert(
      multi,
      {:insert_post, post.original_id},
      post,
      on_conflict: update_properties,
      conflict_target: :original_id
    )
  end

  def hot_in_community(community, count \\ @default_count) do
    Post
    |> where([p], p.community == ^String.downcase(community))
    |> where([p], p.time_posted > ago(1, "day"))
    |> order_by_hotness()
    |> limit(^count)
    |> Repo.all()
  end

  def order_by_hotness(multi) do
    # Hot sorting: Score with a halflife of 5 hours
    # (sorry)
    multi
    |> order_by([u], desc:
    fragment("power(2.71828, -1 * (1.0/5) * least(24 * 30, greatest(0, extract(epoch from now() - ?) / 3600))) * ?", u.time_posted, u.score))
  end

  def with_id(id) do
    post = Post
    |> where([p], p.id == ^id)
    |> Repo.one()

    if post do
      {:ok, post}
    else
      :no_post_with_id
    end
  end
end
