defmodule TicTacToe.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      TicTacToeWeb.Endpoint,
      TicTacToeWeb.Presence
    ]

    opts = [strategy: :one_for_one, name: TicTacToe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TicTacToeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
