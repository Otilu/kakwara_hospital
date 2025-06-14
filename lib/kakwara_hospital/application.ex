defmodule KakwaraHospital.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    # Verify database is accessible before starting
    verify_database_access!()

    children = [
      KakwaraHospitalWeb.Telemetry,
      KakwaraHospital.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:kakwara_hospital, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:kakwara_hospital, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: KakwaraHospital.PubSub},
      {Finch, name: KakwaraHospital.Finch},
      KakwaraHospitalWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: KakwaraHospital.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    KakwaraHospitalWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations? do
    # Skip migrations if running in a release
    System.get_env("RELEASE_NAME") != nil
  end

  defp verify_database_access! do
    db_path = Application.get_env(:kakwara_hospital, KakwaraHospital.Repo)[:database]

    # Ensure directory exists
    File.mkdir_p!(Path.dirname(db_path))

    case File.touch(db_path) do
      :ok ->
        unless sqlite_database_valid?(db_path) do
          initialize_database(db_path)
        end

      {:error, reason} ->
        raise """
        Failed to access database file at #{db_path}: #{reason}
        Ensure:
        1. The parent directory exists and is writable
        2. The filesystem has available space
        3. Render's disk is properly mounted (if using persistent storage)
        """
    end
  end

  defp sqlite_database_valid?(path) do
    case Exqlite.Sqlite3.open(path) do
      {:ok, conn} ->
        Exqlite.Sqlite3.close(conn)
        true
      _ -> false
    end
  end

  defp initialize_database(path) do
    {:ok, conn} = Exqlite.Sqlite3.open(path)

    # Create minimum required tables
    Exqlite.Sqlite3.execute(conn, """
    CREATE TABLE IF NOT EXISTS schema_migrations (
      version TEXT PRIMARY KEY
    )
    """)

    # Add any other essential tables here
    Exqlite.Sqlite3.close(conn)
  end
end
