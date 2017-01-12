defmodule BetterReddit.Router do
  use BetterReddit.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BetterReddit.Plugs.MinifyHTML
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :put_headers, %{"Access-Control-Allow-Origin" => "*"}
  end

  scope "/", BetterReddit do
    get "/", AppController, :index
  end

  scope "/api", BetterReddit.API do
    pipe_through :api
    resources "/communities", CommunityController, only: [:show]
  end
end
