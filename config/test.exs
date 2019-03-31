use Mix.Config

config :tic_tac_toe, TicTacToeWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn
