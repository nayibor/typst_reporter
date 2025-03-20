defmodule TypstReporter.TypstReportTest do
  use TypstReporter.DataCase

  alias TypstReporter.TypstReport

  describe "reports" do
    alias TypstReporter.TypstReport.Report

    import TypstReporter.TypstReportFixtures

    @invalid_attrs %{title: nil, db_query: nil, typst_string: nil, use_default_typst: nil}

    test "list_reports/0 returns all reports" do
      report = report_fixture()
      assert TypstReport.list_reports() == [report]
    end

    test "get_report!/1 returns the report with given id" do
      report = report_fixture()
      assert TypstReport.get_report!(report.id) == report
    end

    test "create_report/1 with valid data creates a report" do
      valid_attrs = %{title: "some title", db_query: "some db_query", typst_string: "some typst_string", use_default_typst: true}

      assert {:ok, %Report{} = report} = TypstReport.create_report(valid_attrs)
      assert report.title == "some title"
      assert report.db_query == "some db_query"
      assert report.typst_string == "some typst_string"
      assert report.use_default_typst == true
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TypstReport.create_report(@invalid_attrs)
    end

    test "update_report/2 with valid data updates the report" do
      report = report_fixture()
      update_attrs = %{title: "some updated title", db_query: "some updated db_query", typst_string: "some updated typst_string", use_default_typst: false}

      assert {:ok, %Report{} = report} = TypstReport.update_report(report, update_attrs)
      assert report.title == "some updated title"
      assert report.db_query == "some updated db_query"
      assert report.typst_string == "some updated typst_string"
      assert report.use_default_typst == false
    end

    test "update_report/2 with invalid data returns error changeset" do
      report = report_fixture()
      assert {:error, %Ecto.Changeset{}} = TypstReport.update_report(report, @invalid_attrs)
      assert report == TypstReport.get_report!(report.id)
    end

    test "delete_report/1 deletes the report" do
      report = report_fixture()
      assert {:ok, %Report{}} = TypstReport.delete_report(report)
      assert_raise Ecto.NoResultsError, fn -> TypstReport.get_report!(report.id) end
    end

    test "change_report/1 returns a report changeset" do
      report = report_fixture()
      assert %Ecto.Changeset{} = TypstReport.change_report(report)
    end
  end
end
