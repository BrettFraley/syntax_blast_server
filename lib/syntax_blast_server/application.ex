defmodule SyntaxBlastServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SyntaxBlastServerWeb.Telemetry,
      SyntaxBlastServer.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:syntax_blast_server, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:syntax_blast_server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SyntaxBlastServer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SyntaxBlastServer.Finch},
      # Start a worker by calling: SyntaxBlastServer.Worker.start_link(arg)
      # {SyntaxBlastServer.Worker, arg},
      # Start to serve requests, typically the last entry
      SyntaxBlastServerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SyntaxBlastServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SyntaxBlastServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
