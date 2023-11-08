import Config

config :tictactoe, Tictactoe.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "tictactoe_test"
