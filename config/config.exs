import Config

# General application configuration
config :kakwara_hospital,
  ecto_repos: [KakwaraHospital.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :kakwara_hospital, KakwaraHospitalWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: KakwaraHospitalWeb.ErrorHTML, json: KakwaraHospitalWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: KakwaraHospital.PubSub,
  live_view: [signing_salt: "m1zr4fHo"]

# Enable endpoint serving in releases
config :phoenix, :serve_endpoints, true

# Configures the mailer
config :kakwara_hospital, KakwaraHospital.Mailer,
  adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  kakwara_hospital: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  kakwara_hospital: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Optional timezone DB config
# config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Import environment-specific config
import_config "#{config_env()}.exs"
