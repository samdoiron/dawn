defmodule RedditGather.PostOutput do
  @moduledoc ~S"""
  A place to send reddit posts when they are gathered.

  Duplicate posts may be sent at different times. Example uses of this
  would be to append to a shared queue (eg. `KafkaPostOutput`).

  For debugging, use `ConsolePostOutput`.
  """

  @callback send(RedditGather.Post) :: :ok | {:error, String.t}
end
