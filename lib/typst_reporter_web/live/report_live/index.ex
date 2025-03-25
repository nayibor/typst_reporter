defmodule TypstReporterWeb.ReportLive.Index do
  use TypstReporterWeb, :live_view

  alias TypstReporter.TypstReport
  alias TypstReporter.TypstReport.Report
  alias TypstReporter.Utils

  @impl true
  def mount(_params, _session, socket) do
    reports = TypstReport.list_reports()
    {:ok,
     socket
     |> assign(:page_data,Utils.paginate(1,length(reports)))
     |>  stream(:reports,reports)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Report")
    |> assign(:report, TypstReport.get_report!(id))
  end

  defp apply_action(socket, :new, _params) do
    IO.inspect socket
    socket
    |> assign(:page_title, "New Report")
    |> assign(:report, %Report{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reports")
    |> assign(:report, nil)
  end

  @impl true
  def handle_info({TypstReporterWeb.ReportLive.FormComponent, {:saved, report}}, socket) do
    reports = TypstReport.list_reports()
    {:noreply,
     socket
     |> assign(:page_data,Utils.paginate(1,length(reports)))
     |> stream(:reports, reports,reset: true)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    report = TypstReport.get_report!(id)
    {:ok, _} = TypstReport.delete_report(report)
    reports = TypstReport.list_reports()
    {:noreply,
     socket
     |> assign(:page_data,Utils.paginate(1,length(reports)))
     |> stream(:reports, reports,reset: true)}
  end

  ##this is for pagination
  @impl true
  def handle_event("paginate", %{"page" => page} = _params, socket) do
    offset = Utils.get_offset(page)
    reports = TypstReport.list_reports(%{offset: offset,limit: Utils.get_page_size(),title: ""})
    {:noreply,
     socket
    |> assign(:page_data,Utils.paginate(page,length(reports)))     
    |> stream(:reports,reports,reset: true)}
  end
end
