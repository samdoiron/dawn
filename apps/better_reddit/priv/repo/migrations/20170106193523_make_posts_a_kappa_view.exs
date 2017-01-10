defmodule BetterReddit.Repo.Migrations.MakePostsAKappaView do
  use Ecto.Migration

  def up do
    execute("DROP VIEW post")
    create table(:post) do
      add :title,       :string, size: 1024, null: false
      add :url,         :string, size: 2048, null: false
      add :author,      :string, size: 2048, null: false
      add :source,      :string,   null: false
      add :original_id, :string,   null: false
      add :score,       :integer,  null: false
      add :community,   :string,   null: false
      add :is_nsfw,     :boolean,  null: false
      add :thumbnail,   :string,   null: true
      add :time_posted, :datetime, null: false
    end

    create index(:post, [:source, :original_id], unique: true)
    create index(:post, [:community])
  end

  def down do
    drop table(:post)
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
