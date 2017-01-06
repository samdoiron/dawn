defmodule BetterReddit.Repo.Migrations.AddThumbnailToRedditPost do
  use Ecto.Migration

  def change do
    alter table(:reddit_post) do
      add :thumbnail, :string, size: 4096
    end
  end
end
