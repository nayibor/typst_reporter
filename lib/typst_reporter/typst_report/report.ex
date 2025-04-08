defmodule TypstReporter.TypstReport.Report do
  use Ecto.Schema
  import Ecto.Changeset

  schema "typst_reports" do
    field :title, :string
    field :db_query, :string
    field :typst_string, :string
    field :use_default_typst, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:title, :db_query, :typst_string, :use_default_typst])
    |> validate_required([:title, :db_query, :use_default_typst])
  end
end
