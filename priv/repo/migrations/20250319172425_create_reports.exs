defmodule TypstReporter.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :title, :string
      add :db_query, :text
      add :typst_string, :text
      add :use_default_typst, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
