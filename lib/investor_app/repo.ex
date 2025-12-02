defmodule InvestorApp.Repo do
  use Ecto.Repo,
    otp_app: :investor_app,
    adapter: Ecto.Adapters.Postgres
end
