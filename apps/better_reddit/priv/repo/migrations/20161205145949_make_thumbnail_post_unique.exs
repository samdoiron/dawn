defmodule BetterReddit.Repo.Migrations.MakeThumbnailPostUnique do
  use Ecto.Migration

  def change do
    create unique_index(:thumbnail, [:reddit_post_id])
  end
end
