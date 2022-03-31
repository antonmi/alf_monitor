defmodule ALFMonitorWeb.PageController do
  use ALFMonitorWeb, :controller

  # iex --sname node2@localhost -S mix phx.server

  def index(conn, _params) do
    render(
      conn,
      "index.html"
    )
  end


end
