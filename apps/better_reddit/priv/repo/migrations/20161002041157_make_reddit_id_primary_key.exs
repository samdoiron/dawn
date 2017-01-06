defmodule BetterReddit.Repo.Migrations.MakeRedditIdPrimaryKey do
  use Ecto.Migration

  def change do
    execute("DELETE FROM reddit_post WHERE reddit_id IS NULL")
    alter table(:reddit_post) do
      remove :id
      modify :reddit_id, :string, primary_key: true
    end
  end
end
