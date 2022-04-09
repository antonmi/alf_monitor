# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :alf_monitor, ALFMonitorWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ALFMonitorWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ALFMonitor.PubSub,
  live_view: [signing_salt: "vdj9ht04"]


# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/* --loader:.js=jsx),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Enum.join([Path.expand("../deps", __DIR__), Path.expand("../assets/node_modules", __DIR__)], ":")}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
