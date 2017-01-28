defmodule RedditGather.ActualTime do
  @behaviour RedditGather.Time

  def sleep_ms(milliseconds) do
    Process.sleep(milliseconds)
  end
end
