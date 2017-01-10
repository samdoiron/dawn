defmodule BetterReddit.Repo.Migrations.MakeOriginalIdUnique do
  use Ecto.Migration

  def change do
    create unique_index(:post, [:original_id])
  end
end
