use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :shorty, Shorty.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
#
# Configure your database
config :shorty, Shorty.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("PG_DATABASE") || "shorty_test",
  hostname: System.get_env("PG_HOSTNAME") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
