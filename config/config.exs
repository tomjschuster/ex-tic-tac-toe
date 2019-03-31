use Mix.Config

config :tic_tac_toe, TicTacToeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "keyboardcat",
  render_errors: [view: TicTacToeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TicTacToe.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: System.get_env("LIVE_VIEW_SALT") || "NaCl"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :phoenix, :template_engines, leex: Phoenix.LiveView.Engine

import_config "#{Mix.env()}.exs"
