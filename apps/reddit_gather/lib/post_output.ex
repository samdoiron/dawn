defmodule RedditGather.PostOutput do
  @callback send(RedditGather.Post) :: :ok | {:error, String.t}
end