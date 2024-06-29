defmodule Kans.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KansWeb.Telemetry,
      Kans.Repo,
      {DNSCluster, query: Application.get_env(:kans, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Kans.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Kans.Finch},
      # Start a worker by calling: Kans.Worker.start_link(arg)
      # {Kans.Worker, arg},
      # Start to serve requests, typically the last entry
      KansWeb.EndpointActuator,
      KansWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kans.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KansWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
