defmodule TicTacToeWeb.Router do
  use TicTacToeWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(Phoenix.LiveView.Flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:put_layout, {TicTacToeWeb.LayoutView, :app})
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TicTacToeWeb do
    pipe_through(:browser)
    live("/", GameLive)
  end
end
