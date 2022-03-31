defmodule ALFMonitorWeb.Router do
  use ALFMonitorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ALFMonitorWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ALFMonitorWeb do
    pipe_through :browser

#    get "/", PageController, :index
    live "/", GraphLive
  end
end
