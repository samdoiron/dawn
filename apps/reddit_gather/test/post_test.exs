defmodule RedditGatherTest.PostTest do
  use ExUnit.Case, async: true

  alias RedditGather.Post

  test "posts can be json encoded" do
    Poison.encode!(%Post{})
  end
end