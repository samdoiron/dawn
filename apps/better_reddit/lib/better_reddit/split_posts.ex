alias Experimental.GenStage

defmodule BetterReddit.SplitPosts do
  use GenStage
  alias BetterReddit.Schemas

  def start_link(name) do
    GenStage.start_link(__MODULE__, [], name: name)
  end

  def init([]) do
    {:producer_consumer, [],
     dispatcher: {GenStage.PartitionDispatcher,
                  partitions: [:old, :new],
                  hash: &label_hash/1}}
  end

  def handle_events(posts, _from, state) do
    existing = fetch_all_matching(posts)
    labeled = label_new_and_old(posts, existing)
    {:noreply, labeled, state}
  end

  def fetch_all_matching(posts) do
    ids = Enum.map(posts, &(&1.original_id))
    Schemas.Post.with_original_ids(ids)
  end

  def label_new_and_old(posts, existing) do
    Enum.map posts, fn post ->
      old = Enum.find(existing, &(&1.original_id == post.original_id))
      if old == nil do
        {post, :new}
      else
        {Schemas.Post.merge(old, post), :old}
      end
    end
  end

  def label_hash({post, label}), do: {post, label}
end