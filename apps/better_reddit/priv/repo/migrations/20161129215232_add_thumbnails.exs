defmodule BetterReddit.Repo.Migrations.AddThumbnails do
  use Ecto.Migration

  def change do
    create table(:thumbnail) do
      add :source_url, :string, length: 2048, null: false
    end
  end
end
