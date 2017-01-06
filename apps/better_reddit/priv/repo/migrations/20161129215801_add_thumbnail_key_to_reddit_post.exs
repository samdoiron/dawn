defmodule BetterReddit.Repo.Migrations.AddThumbnailKeyToRedditPost do
  use Ecto.Migration

  def change do
    rename table(:reddit_post), :thumbnail, to: :thumbnail_url
    alter table(:reddit_post) do
      add :thumbnail_id, :integer
    end
  end
end
