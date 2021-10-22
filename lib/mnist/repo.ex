defmodule Mnist.Repo do
  use Ecto.Repo,
    otp_app: :mnist,
    adapter: Ecto.Adapters.Postgres
end
