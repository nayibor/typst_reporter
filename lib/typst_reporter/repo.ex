defmodule TypstReporter.Repo do
  use Ecto.Repo,
    otp_app: :typst_reporter,
    adapter: Ecto.Adapters.Postgres
end
