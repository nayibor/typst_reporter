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
    socket
    |> assign(:page_title, "New Report")
    |> assign(:report, %Report{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reports")
    |> assign(:form, %{})
    |> assign(:report, nil)
  end

  @impl true
  def handle_info({TypstReporterWeb.ReportLive.FormComponent, {:saved, _report}}, socket) do
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

  ##this is for an empty search
  @impl true
  def handle_event("search", %{"title" => ""} =  _params, socket) do
    reports = TypstReport.list_reports()
    {:noreply,
     socket
     |> assign(:page_data,Utils.paginate(1,length(reports)))
     |> stream(:reports, reports,reset: true)}     
    
  end

  ##this is for a search with a real value
  ##limit has been made big so whole search result can fit on page
  ##pagination result returned will fit on one page no matter size of result
  def handle_event("search", %{"title" => title} = _params, socket) do
    reports = TypstReport.list_reports(%{offset: 0,limit: 10000,title: title})
    {:noreply,
     socket
    |> assign(:page_data,%{cpage: 1, next_page_show: false})
    |> stream(:reports, reports,reset: true)}
  end

  
end
