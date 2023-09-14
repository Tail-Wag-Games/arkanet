defmodule Arkanet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ArkanetWeb.Telemetry,
      # Start the Ecto repository
      Arkanet.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Arkanet.PubSub},
      # Start Finch
      {Finch, name: Arkanet.Finch},
      # Start Phoenix Presence
      ArkanetWeb.Presence,
      # Start cache
      {Cachex, name: :lobby_hosts},
      # Start the Endpoint (http/https)
      ArkanetWeb.Endpoint,
      # Start STUN server
      ArkanetWeb.Stun
      # Start a worker by calling: Arkanet.Worker.start_link(arg)
      # {Arkanet.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Arkanet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ArkanetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
