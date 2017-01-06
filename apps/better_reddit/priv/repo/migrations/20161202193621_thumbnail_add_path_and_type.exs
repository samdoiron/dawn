defmodule BetterReddit.Repo.Migrations.ThumbnailAddPathAndType do
  use Ecto.Migration

  def change do
    alter table(:thumbnail) do
      add :file_name, :string
      add :content_type, :string
    end
  end
end
