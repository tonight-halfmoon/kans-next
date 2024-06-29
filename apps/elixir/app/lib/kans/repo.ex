defmodule Kans.Repo do
  use Ecto.Repo,
    otp_app: :kans,
    adapter: Ecto.Adapters.Postgres
end
