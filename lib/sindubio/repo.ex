defmodule Sindubio.Repo do
  use Ecto.Repo,
    otp_app: :sindubio,
    adapter: Ecto.Adapters.Postgres
end
