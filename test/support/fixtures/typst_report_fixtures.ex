defmodule TypstReporter.TypstReportFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TypstReporter.TypstReport` context.
  """

  @doc """
  Generate a report.
  """
  def report_fixture(attrs \\ %{}) do
    {:ok, report} =
      attrs
      |> Enum.into(%{
        db_query: "some db_query",
        title: "some title",
        typst_string: "some typst_string",
        use_default_typst: true
      })
      |> TypstReporter.TypstReport.create_report()

    report
  end
end
