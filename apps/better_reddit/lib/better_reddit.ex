defmodule BetterReddit do
  use Application

  @moduledoc ~S"""
  The root module for BetterReddit. Calling start starts the entire application,
  including the websercer, and gatherer.
  """

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(BetterReddit.Endpoint, []),
      supervisor(BetterReddit.PostSupervisor, []),
      worker(BetterReddit.Repo, []),
    ]

    opts = [strategy: :one_for_one, name: Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
