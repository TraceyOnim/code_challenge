import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bleacher_user_reaction, BURWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ieGcwOHsY4t8B6+arl54a+v9F6a6CSgU4hFiygkttkPQtNj5S6n/iqS4WtDwJrON",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
