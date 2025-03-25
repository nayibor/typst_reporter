defmodule TypstReporterWeb.ReportLive.FormComponent do
  use TypstReporterWeb, :live_component

  alias TypstReporter.TypstReport

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage report records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="report-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:db_query]} type="textarea" label="Db query" />
        <.input field={@form[:typst_string]} type="textarea" label="Typst string" />
        <.input field={@form[:use_default_typst]} type="checkbox" label="Use default typst" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Report</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{report: report} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(TypstReport.change_report(report))
     end)}
  end

  @impl true
  def handle_event("validate", %{"report" => report_params}, socket) do
    changeset = TypstReport.change_report(socket.assigns.report, report_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"report" => report_params}, socket) do
    save_report(socket, socket.assigns.action, report_params)
  end

  defp save_report(socket, :edit, report_params) do
    case TypstReport.update_report(socket.assigns.report, report_params) do
      {:ok, report} ->
        notify_parent({:saved, report})

        {:noreply,
         socket
         |> put_flash(:info, "Report updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_report(socket, :new, report_params) do
    case TypstReport.create_report(report_params) do
      {:ok, report} ->
        notify_parent({:saved, report})

        {:noreply,
         socket
         |> put_flash(:info, "Report created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
