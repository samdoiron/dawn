defmodule BetterReddit.Repo.Migrations.CreateRedditComments do
  use Ecto.Migration

  def change do
    create table(:reddit_comment) do
      add :parent, references(:reddit_comment)
      add :reddit_post_id, :string, null: false
      add :reddit_id, :string, null: false
      add :content, :string, null: false
      add :ups, :integer, null: false
      add :downs, :integer, null: false
      add :author, :string, null: false
      add :time_posted, :datetime, null: false
      add :time_edited, :datetime, null: false
    end

    create index(:reddit_comment, [:reddit_post_id])
    create index(:reddit_comment, [:parent])
    create unique_index(:reddit_comment, [:reddit_id])
  end
end
