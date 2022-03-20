# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :titeenipeli,
  ecto_repos: [Titeenipeli.Repo]

# Configures the endpoint
config :titeenipeli, TiteenipeliWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TiteenipeliWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Titeenipeli.PubSub,
  live_view: [signing_salt: "m/70CJhl"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Rate limiting
config :hammer,
  backend: {Hammer.Backend.ETS, [expiry_ms: 60_000 * 60 * 4, cleanup_interval_ms: 60_000 * 10]}

# Authentication
config :titeenipeli, Titeenipeli.Auth.Guardian,
  issuer: "RuffeCS",
  secret_key: Map.fetch!(System.get_env(), "GUARDIAN_SECRET_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
