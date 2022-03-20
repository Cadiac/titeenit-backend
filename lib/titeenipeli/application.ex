defmodule Titeenipeli.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Start the Ecto repository
      Titeenipeli.Repo,
      # Start the Telemetry supervisor
      TiteenipeliWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Titeenipeli.PubSub},
      # Start the Endpoint (http/https)
      TiteenipeliWeb.Endpoint,
      # Start a worker by calling: Titeenipeli.Worker.start_link(arg)
      # {Titeenipeli.Worker, arg}

      # TODO: This is using the deprecated Supervisor.Spec.Worker/2, which was still ok in 2020 but is deprecated now.
      # This code won't probably work with future versions of Elixir (> 1.13.3), and the new child specifications should
      # be used instead, but as this was a short lived project I didn't bother to update it.
      worker(Titeenipeli.Poller, []),
      supervisor(Titeenipeli.Game.Supervisor, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Titeenipeli.Supervisor]
    pid = Supervisor.start_link(children, opts)

    # Start games for each guild & zone
    guilds = Titeenipeli.Repo.all(Titeenipeli.Model.Guild)

    Titeenipeli.Repo.all(Titeenipeli.Model.Zone)
    |> Enum.each(fn zone ->
      Enum.each(guilds, fn guild ->
        Titeenipeli.Game.Supervisor.create_game("#{guild.id}", "#{zone.id}")
      end)
    end)

    pid
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TiteenipeliWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
