defmodule BetterReddit.Repo.Migrations.AddNsfwToPost do
  use Ecto.Migration

  def up do
    execute("drop view post")
    execute(~s"""
    create view post as (
      select reddit_id::varchar(255) as source_id,
        title::text, url::text, author::text,
        time_posted::timestamp, 'reddit'::varchar(255) as source,
        (ups - downs)::integer as score,
        subreddit::varchar(255) as topic,
        thumbnail.file_name::varchar(255) as thumbnail,
        is_nsfw::boolean
        from reddit_post
        left outer join thumbnail
          on reddit_post.reddit_id = thumbnail.reddit_post_id
    )
    """)
  end

  def down do
    execute("drop view post")
    execute(~s"""
    create view post as (
      select reddit_id::varchar(255) as source_id,
        title::text, url::text, author::text,
        time_posted::timestamp, 'reddit'::varchar(255) as source,
        (ups - downs)::integer as score,
        subreddit::varchar(255) as topic,
        thumbnail.file_name::varchar(255) as thumbnail
        from reddit_post
        left outer join thumbnail
          on reddit_post.reddit_id = thumbnail.reddit_post_id
    )
    """)
  end
end
