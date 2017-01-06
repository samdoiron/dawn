defmodule BetterReddit.Repo.Migrations.CascadeDeleteThumbnails do
  use Ecto.Migration

  def up do
    execute("drop view post")

    drop constraint(:thumbnail, "thumbnail_reddit_post_id_fkey")
    alter table(:thumbnail) do
      modify :reddit_post_id, references(
        :reddit_post,
        type: :string,
        column: :reddit_id,
        on_delete: :delete_all
      ), size: 4096
    end

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

    drop constraint(:thumbnail, "thumbnail_reddit_post_id_fkey")
    alter table(:thumbnail) do
      modify :reddit_post_id, references(
        :reddit_post,
        type: :string,
        column: :reddit_id,
        on_delete: :nothing
      ), size: 4096
    end

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
end
