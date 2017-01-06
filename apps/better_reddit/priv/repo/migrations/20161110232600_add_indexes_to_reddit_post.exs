defmodule BetterReddit.Repo.Migrations.AddIndexesToRedditPost do
  use Ecto.Migration

  def change do
    create index(:reddit_post, [:time_posted])
    create index(:reddit_post, [:subreddit])
  end
end
