import Config

# Configure your PostgreSQL database for testing
config :kakwara_hospital, KakwaraHospital.Repo,
  username: "postgres",
  password: "your_password", # 🔁 Replace with your actual PostgreSQL password
  hostname: "localhost",
  port: 5432,
  database: "kakwara_hospital_test",
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kakwara_hospital, KakwaraHospitalWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "KQ8g/ZeNg5mmBN7KfckVngACSUM05CfOdZjq3epmL40IxyEF6kxg5guYmuO1y+fw",
  server: false

# In test we don't send emails
config :kakwara_hospital, KakwaraHospital.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
