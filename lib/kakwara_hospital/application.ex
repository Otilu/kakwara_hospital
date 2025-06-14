defmodule KakwaraHospital.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Telemetry and Observability
      KakwaraHospitalWeb.Telemetry,

      # Ecto Repo (PostgreSQL)
      KakwaraHospital.Repo,

      # Run migrations at startup if not in release
      {Ecto.Migrator,
        repos: Application.fetch_env!(:kakwara_hospital, :ecto_repos),
        skip: skip_migrations?()},

      # DNS clustering
      {DNSCluster, query: Application.get_env(:kakwara_hospital, :dns_cluster_query) || :ignore},

      # PubSub and HTTP
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
end
