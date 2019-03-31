use Mix.Config

config :tic_tac_toe, TicTacToeWeb.Endpoint,
  http: [port: 4000],
  # https: [port: 4001, certfile: "priv/cert/selfsigned.pem", keyfile: "priv/cert/selfsigned_key.pem"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  protocol_options: [
    max_header_name_length: 64,
    max_header_value_length: 140_096,
    max_headers: 100
  ],
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      "--display",
      "minimal",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :tic_tac_toe, TicTacToeWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/tic_tac_toe_web/views/.*(ex)$},
      ~r{lib/tic_tac_toe_web/templates/.*(eex)$},
      ~r{lib/tic_tac_toe_web/live/.*(ex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"
config :logger, level: :debug

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
