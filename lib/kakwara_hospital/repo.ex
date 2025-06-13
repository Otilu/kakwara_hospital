defmodule KakwaraHospital.Repo do
  use Ecto.Repo,
    otp_app: :kakwara_hospital,
    adapter: Ecto.Adapters.SQLite3
end
