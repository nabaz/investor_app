defmodule InvestorApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InvestorAppWeb.Telemetry,
      InvestorApp.Repo,
      {DNSCluster, query: Application.get_env(:investor_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: InvestorApp.PubSub},
      # Start a worker by calling: InvestorApp.Worker.start_link(arg)
      # {InvestorApp.Worker, arg},
      # Start to serve requests, typically the last entry
      InvestorAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InvestorApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InvestorAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
