import Config

config :tictactoe, Tictactoe.Repo,
  database: "tictactoe_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :tictactoe, ecto_repos: [Tictactoe.Repo]

config :alf, telemetry: true

import_config "#{config_env()}.exs"
