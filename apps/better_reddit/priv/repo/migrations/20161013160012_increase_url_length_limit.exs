defmodule BetterReddit.Repo.Migrations.IncreaseUrlLengthLimit do
  use Ecto.Migration

  def change do
    execute("DROP VIEW post")
    alter table(:reddit_post) do
      modify :url, :string, size: 4096
    end
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
end
