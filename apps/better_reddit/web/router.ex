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
  end

  scope "/api", BetterReddit.API do
  end
end
