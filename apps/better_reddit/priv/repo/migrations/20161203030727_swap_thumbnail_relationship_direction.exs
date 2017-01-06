defmodule BetterReddit.Repo.Migrations.SwapThumbnailRelationshipDirection do
  use Ecto.Migration

  def change do
    alter table(:reddit_post) do
      remove :thumbnail_id
    end

    alter table(:thumbnail) do
      add :reddit_post_id, references(
        :reddit_post,
        type: :string,
        column: :reddit_id
      )
    end
  end
end
