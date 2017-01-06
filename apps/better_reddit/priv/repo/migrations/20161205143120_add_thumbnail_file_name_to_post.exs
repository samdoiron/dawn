defmodule BetterReddit.Repo.Migrations.AddThumbnailFileNameToPost do
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
        thumbnail.file_name::VARCHAR(255) as thumbnail
        FROM reddit_post
        LEFT OUTER JOIN thumbnail
          ON reddit_post.reddit_id = thumbnail.reddit_post_id
    )
    """)
  end

  def down do
    execute("DROP VIEW post")
    execute(~S"""
    CREATE VIEW post AS (
      SELECT reddit_id::VARCHAR(255) as source_id,
        title::text, url::text, author::text,
        time_posted::timestamp, 'reddit'::VARCHAR(255) as source,
        (ups - downs)::integer as score,
        subreddit::VARCHAR(255) as topic,
        thumbnail_url::text as thumbnail
        FROM reddit_post
    )
    """)
  end
end
