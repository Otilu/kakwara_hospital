import Config

if config_env() == :prod do
  # Database
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: postgres://USER:PASS@HOST/DATABASE
      """

  config :kakwara_hospital, KakwaraHospital.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true,
    socket_options: [:inet6]

  # Endpoint
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "environment variable SECRET_KEY_BASE is missing."

  host = System.get_env("PHX_HOST") || "kakwara-hospital.onrender.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  IO.puts("Starting app on #{host}:#{port}")

  config :kakwara_hospital, KakwaraHospitalWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0},
      port: port,
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base,
    server: true,
    check_origin: ["https://#{host}", "http://#{host}"]

  # Optional clustering or discovery
  config :kakwara_hospital, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  # Logger (recommended for production)
  config :logger, level: :info

  # Required for endpoint serving
  config :phoenix, :serve_endpoints, true
end
