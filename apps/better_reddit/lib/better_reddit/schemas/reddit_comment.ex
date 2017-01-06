defmodule BetterReddit.Schemas.RedditComment do
  use Ecto.Schema
  alias BetterReddit.Schemas

  schema "reddit_comment" do
    belongs_to :reddit_post, Schemas.RedditPost
    belongs_to :parent, Schemas.RedditComment
    has_many :children, Schemas.RedditComment

    field :content, :string, null: false
    field :ups, :integer, null: false
    field :downs, :integer, null: false
    field :author, :string, null: false
    field :time_posted, Timex.Ecto.DateTime, null: false
    field :time_edited, Timex.Ecto.DateTime
  end
end
