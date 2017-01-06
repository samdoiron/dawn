defmodule BetterReddit.Repo.Migrations.IncreaseRedditPostTitleLength do
  use Ecto.Migration

  def change do
    # Must drop / recreate post view since this changes its type
    execute("DROP VIEW post")
    alter table(:reddit_post) do
      modify :title, :string, size: 300
    end
    execute(~S"""
    CREATE VIEW post AS (
      SELECT title, url, author,
             time_posted, 'reddit' as source
      FROM reddit_post
    )
    """)
  end
end
