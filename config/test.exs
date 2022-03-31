import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :alf_monitor, ALFMonitorWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bhJcSnW5YzxzP+acfbklUiM4gQ8Inismz3IHlol22d9bZ9XEJ5W+j26UCIwyB8HM",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
