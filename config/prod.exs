import Config

config :alf_monitor, ALFMonitorWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info
