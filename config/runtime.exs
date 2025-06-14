import Config

if config_env() == :prod do
  # =============================================
  # 1. Database Configuration (SQLite)
  # =============================================
  database_path =
    System.get_env("DATABASE_PATH") ||
    Path.join(System.get_env("RENDER_INSTANCE_ID") || "/tmp", "kakwara_hospital.db")

  # Safely create database directory and file
  case File.mkdir_p(Path.dirname(database_path)) do
    :ok ->
      case File.touch(database_path) do
        :ok -> :ok
        {:error, reason} ->
          raise "Failed to create database file at #{database_path}: #{inspect(reason)}"
      end
    {:error, reason} ->
      raise "Failed to create database directory for #{database_path}: #{inspect(reason)}"
  end

  config :kakwara_hospital, KakwaraHospital.Repo,
    database: database_path,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5"),
    show_sensitive_data_on_connection_error: false,
    # Add SQLite pragmas for better performance
    pragmas: [
      "journal_mode = WAL",
      "synchronous = NORMAL"
    ]

  # =============================================
  # 2. Endpoint Configuration
  # =============================================
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :kakwara_hospital, KakwaraHospitalWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0},
      port: port,
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base,
    server: true,
    root: ".",
    version: Application.spec(:kakwara_hospital, :vsn),
    cache_static_manifest: "priv/static/cache_manifest.json",
    # Render-specific optimizations
    check_origin: ["https://#{host}"]

  # =============================================
  # 3. Additional Production Config
  # =============================================
  config :kakwara_hospital, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  # Configures Swoosh API Client
  config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: KakwaraHospital.Finch

  # Logger configuration
  config :logger,
    level: :info,
    format: "$time $metadata[$level] $message\n",
    metadata: [:request_id]

  # Runtime production configuration
  config :phoenix, :serve_endpoints, true
end
