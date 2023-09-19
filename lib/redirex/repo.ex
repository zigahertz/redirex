defmodule Redirex.Repo do
  use Ecto.Repo,
    otp_app: :redirex,
    adapter: Ecto.Adapters.Postgres
end
