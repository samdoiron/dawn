defmodule BetterReddit.Reddit do
  use Supervisor
  alias BetterReddit.Reddit

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Reddit.Gather, []),
    ]

    opts = [strategy: :one_for_one]

    supervise(children, opts)
  end
end
