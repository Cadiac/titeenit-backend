defmodule Titeenipeli.Game.Supervisor do
  @moduledoc """
  Game Supervisor
  """
  use Supervisor
  require Logger

  alias Titeenipeli.Game

  @name Titeenipeli.Game.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    Logger.debug("Starting Titeenipeli.Game.Supervisor")

    # TODO: This is using the deprecated Supervisor.Spec.Worker/2, which was still ok in 2020 but is deprecated now.
    # This code won't probably work with future versions of Elixir (> 1.13.3), and the new child specifications should
    # be used instead, but as this was a short lived project I didn't bother to update it.
    children = [
      worker(Game, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  @doc """
  Creates a new supervised Game process
  """
  def create_game(guild_id, zone_id) do
    Supervisor.start_child(@name, [guild_id <> ":" <> zone_id])
  end

  def stop_game(game_id) do
    Logger.debug("Stopping game #{game_id} in supervisor")

    pid = GenServer.whereis({:global, {:game, game_id}})

    Supervisor.terminate_child(__MODULE__, pid)
  end

  def activate_reward_buff(guild_id, zone_id, buff_id) do
    Logger.debug("Signal zone #{guild_id}:#{zone_id} that guild has been rewarded with buff #{buff_id}")
    pid = GenServer.whereis({:global, {:game, "#{guild_id}:#{zone_id}"}})

    GenServer.cast(pid, {:activate_reward_buff, buff_id})
  end

  def signal_unlock_zone(guild_id, zone_id) do
    Logger.debug("Signal that zone #{guild_id}:#{zone_id} has been unlocked ")
    pid = GenServer.whereis({:global, {:game, "#{guild_id}:#{zone_id}"}})

    GenServer.cast(pid, :signal_zone_unlocked)
  end

  def signal_reward_exp(guild_id, zone_id, user, is_levelup, experience_reward) do
    Logger.debug("Signal zone #{guild_id}:#{zone_id} that player #{user.id} has been rewarded with #{experience_reward} experience.")
    pid = GenServer.whereis({:global, {:game, "#{guild_id}:#{zone_id}"}})

    GenServer.cast(pid, {:signal_reward_exp, user, is_levelup, experience_reward})
  end

  @doc """
  Returns a list of the current games
  """
  def current_games do
    __MODULE__
    |> Supervisor.which_children()
    |> Enum.map(&game_data/1)
  end

  defp game_data({_id, pid, _type, _modules}) do
    pid
    |> GenServer.call(:get_status)
  end
end
