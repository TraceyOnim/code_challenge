defmodule BUR.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BURWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BUR.PubSub},
      # Start the Endpoint (http/https)
      BURWeb.Endpoint,
      BUR.ResponseServer
      # Start a worker by calling: BUR.Worker.start_link(arg)
      # {BUR.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BUR.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BURWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
