import Config

# Configure your PostgreSQL database
config :kakwara_hospital, KakwaraHospital.Repo,
  username: "postgres",
  password: "postgres", # 🔁 Replace with your actual PostgreSQL password
  hostname: "localhost",
  port: 5432,
  database: "kakwara_hospital_dev",
  pool_size: 40,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

# Development server configuration
config :kakwara_hospital, KakwaraHospitalWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "1KCq7avZ2d+tT1xyAaqnr3oCEoRJvy4fwjGceBS7DKzkwrCaLaslU0B+k7pt13lR",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:kakwara_hospital, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:kakwara_hospital, ~w(--watch)]}
  ]

# Live reload patterns
config :kakwara_hospital, KakwaraHospitalWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/kakwara_hospital_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes
config :kakwara_hospital, dev_routes: true

# Logger settings
config :logger, :console, format: "[$level] $message\n"

# Phoenix settings
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

# Phoenix LiveView debug settings
config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true

# Disable Swoosh API client in dev
config :swoosh, :api_client, false
