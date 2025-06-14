import Config

if config_env() == :prod do
  # Database configuration
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: postgres://user:password@hostname/database
      """

  config :kakwara_hospital, KakwaraHospital.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true,
    socket_options: [:inet6]  # Important for Render

  # Endpoint configuration
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "environment variable SECRET_KEY_BASE is missing."

  host = System.get_env("PHX_HOST") || "kakwara-hospital.onrender.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :kakwara_hospital, KakwaraHospitalWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0},
      port: port,
      transport_options: [socket_opts: [:inet6]]  # Important for Render
    ],
    secret_key_base: secret_key_base,
    server: true,
    check_origin: ["https://#{host}"]

  # Other production config
  config :kakwara_hospital, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")
  config :phoenix, :serve_endpoints, true
end
