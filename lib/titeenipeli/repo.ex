defmodule Titeenipeli.Repo do
  use Ecto.Repo,
    otp_app: :titeenipeli,
    adapter: Ecto.Adapters.Postgres
end
