use Mix.Config

config :tic_tac_toe, TicTacToeWeb.Endpoint,
  load_from_system_env: true,
  url: [host: "tictactoe.tomjschuster.dev", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

import_config "prod.secret.exs"
