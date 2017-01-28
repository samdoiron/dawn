defmodule RedditGather.GatherTopTest do
  use ExUnit.Case
  alias RedditGather.{GatherTop, TestFetch, TestTime, MockPostOutput}

  @reddit_rate_limit_ms 2_000

  test "sent requests respect the rate limit" do
    {:ok, _} = TestTime.start_link()
    {:ok, _} = MockPostOutput.start_link()
    {:ok, _gather} = GatherTop.start_link(&TestFetch.recording/1)

    # Give gather time to make it's first request
    Process.sleep(50)
    assert @reddit_rate_limit_ms <= TestTime.time_passed()
  end
end
