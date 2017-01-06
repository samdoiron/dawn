defmodule BetterReddit.Repo.Migrations.AddNsfwToRedditPost do
  use Ecto.Migration

  def change do
    alter table(:reddit_post) do
      add :is_nsfw, :boolean, null: false, default: false
    end
  end
end
