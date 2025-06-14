defmodule KakwaraHospital.Repo do
  use Ecto.Repo,
    otp_app: :kakwara_hospital,
    adapter: Ecto.Adapters.Postgres
end
