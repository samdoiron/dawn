defmodule BetterReddit.Repo.Migrations.CreateRedditPost do
  use Ecto.Migration

  def change do
    create table(:reddit_post) do
      add :reddit_id, :string
      add :title, :string
      add :ups, :integer
      add :downs, :integer
      add :url, :string
      add :author, :string
      add :subreddit, :string
      add :time_posted, :datetime
    end
    create index(:reddit_post, [:reddit_id])
  end
end
