defmodule BetterReddit.Repo.Migrations.AddTopicToPost do
  use Ecto.Migration

  def up do
    execute("DROP VIEW post")
    execute(~S"""
    CREATE VIEW post AS (
      SELECT title, url, author,
             time_posted, 'reddit' as source,
             subreddit as topic
      FROM reddit_post
    )
    """)
  end

  def down do
    execute("DROP VIEW post")
    execute(~S"""
    CREATE VIEW post AS (
      SELECT title, url, author,
             time_posted, 'reddit' as source
      FROM reddit_post
    """)
  end
end
