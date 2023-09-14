defmodule Arkanet.Repo do
  use Ecto.Repo,
    otp_app: :arkanet,
    adapter: Ecto.Adapters.Postgres
end
