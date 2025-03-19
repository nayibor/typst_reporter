defmodule TypstReporter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TypstReporterWeb.Telemetry,
      TypstReporter.Repo,
      {DNSCluster, query: Application.get_env(:typst_reporter, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TypstReporter.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TypstReporter.Finch},
      # Start a worker by calling: TypstReporter.Worker.start_link(arg)
      # {TypstReporter.Worker, arg},
      # Start to serve requests, typically the last entry
      TypstReporterWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TypstReporter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TypstReporterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
