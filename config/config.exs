# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :shorty,
  ecto_repos: [Shorty.Repo]

# Configures the endpoint
config :shorty, Shorty.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BDPsJvwqaiQUHjeW91Be9ap1OBFawxzgg2IJ4stOFcJnxFfGq8rdK/5suLxqgR0w",
  render_errors: [view: Shorty.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Shorty.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure your database
config :shorty, Shorty.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("PG_DATABASE") || "shorty_dev",
  username: System.get_env("PG_USERNAME") || "postgres",
  password: System.get_env("PG_PASSWORD"),
  hostname: System.get_env("PG_HOSTNAME") || "localhost",
  pool_size: 10

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
