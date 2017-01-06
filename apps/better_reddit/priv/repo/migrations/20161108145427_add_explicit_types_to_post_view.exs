defmodule BetterReddit.Repo.Migrations.AddExplicitTypesToPostView do
  use Ecto.Migration

  def up do
    execute("DROP VIEW post")
    execute(~S"""
    CREATE VIEW post AS (
      SELECT reddit_id::VARCHAR(255) as source_id,
        title::text, url::text, author::text,
        time_posted::timestamp, 'reddit'::VARCHAR(255) as source,
        (ups - downs)::integer as score,
        subreddit::VARCHAR(255) as topic,
        thumbnail::text
        FROM reddit_post
    )
    """)
  end


  def down do
    execute("DROP VIEW post")
    execute(~S"""
    CREATE VIEW post AS (
    SELECT CAST(reddit_id AS VARCHAR(255)) as source_id,
    title, url, author,
    time_posted, 'reddit' as source,
    ups - downs as score,
    subreddit as topic,
    thumbnail
    FROM reddit_post
    )
    """)
  end
end
