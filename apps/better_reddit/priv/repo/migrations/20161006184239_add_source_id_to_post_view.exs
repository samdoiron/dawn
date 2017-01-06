defmodule BetterReddit.Repo.Migrations.AddSourceIdToPostView do
  use Ecto.Migration

  def up do
    execute("DROP VIEW post")
    execute(~S"""
      CREATE VIEW post AS (
        SELECT CAST(reddit_id AS VARCHAR(255)) as source_id,
               title, url, author,
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
      time_posted, 'reddit' as source,
      subreddit as topic
      FROM reddit_post
    )
    """)
  end
end
