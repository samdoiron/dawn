defmodule BetterReddit.Repo.Migrations.CreatePostsView do
  use Ecto.Migration

  def up do
    execute(~S"""
    CREATE VIEW post AS (
      SELECT title, url, author,
             time_posted, 'reddit' as source
      FROM reddit_post
    )
    """)
  end

  def down do
    execute("DROP VIEW post")
  end
end
