import Config

if config_env() == :prod do
  config :kakwara_hospital, KakwaraHospitalWeb.Endpoint, server: true

  database_path =
    System.get_env("DATABASE_PATH") || "/tmp/kakwara_hospital.db"

  config :kakwara_hospital, KakwaraHospital.Repo,
    database: database_path,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :kakwara_hospital, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :kakwara_hospital, KakwaraHospitalWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end
