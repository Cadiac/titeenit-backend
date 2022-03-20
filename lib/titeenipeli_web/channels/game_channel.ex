defmodule TiteenipeliWeb.GameChannel do
  use TiteenipeliWeb, :channel
  require Logger
  alias Titeenipeli.Game
  alias Titeenipeli.Core
  alias Titeenipeli.Model.User
  alias TiteenipeliWeb.GameView

  @ratelimit_period 10_000
  @ratelimit_count 100

  def join("game:" <> game_id, _payload, socket) do
    player_id = socket.assigns.player_id

    Logger.debug("#{player_id} is joining Game channel #{game_id}")

    case Hammer.check_rate("game_channel:#{player_id}", @ratelimit_period, @ratelimit_count) do
      {:allow, _count} ->
        with [game_guild_id, _game_zone_id] <- String.split(game_id, ":") do
          # Make sure player guild matches game_id
          %User{guild_id: user_guild_id, is_banned: is_banned} = Core.get_user!(player_id)

          cond do
            is_banned ->
              {:error, %{reason: "Banned."}}

            "#{user_guild_id}" != game_guild_id ->
              {:error, %{reason: "Refused connection, not your guild"}}

            true ->
              case Game.player_connected(game_id, player_id, socket.channel_pid) do
                {:ok, pid} ->
                  Process.monitor(pid)
                  status = Game.get_status(game_id, player_id)

                  {:ok, GameView.render("game_status.json", status, player_id),
                  assign(socket, :game_id, game_id)}

                {:error, reason} ->
                  {:error, %{reason: reason}}
              end
          end
        else
          _err ->
            {:error, %{reason: "Invalid game_id"}}
        end

      {:deny, _limit} ->
        Logger.warn("#{player_id} game_channel ratelimit hit at join!")
        {:error, GameView.render("error.json", %{reason: "Slow down, rate limit exceeded. (10req/s)"})}
    end
  end

  def terminate(reason, socket) do
    Logger.debug("Terminating GameChannel #{socket.assigns.player_id} - #{inspect(reason)}")

    with %{player_id: player_id, game_id: game_id} <- socket.assigns do
      Game.player_disconnected(game_id, player_id)
      :ok
    else
      _err ->
        :ok
    end
  end

  # Commands

  def handle_in("game:begin_cast", %{"spell_id" => spell_id}, socket) when is_number(spell_id) do
    player_id = socket.assigns.player_id
    game_id = socket.assigns.game_id

    case Hammer.check_rate("game_channel:#{player_id}", @ratelimit_period, @ratelimit_count) do
      {:allow, _count} ->
        case Game.begin_cast(game_id, player_id, spell_id) do
          {:ok, result} ->
            {:reply, {:ok, GameView.render("begin_cast.json", result)}, socket}

          {:error, message} ->
            {:reply, {:error, GameView.render("error.json", %{reason: message})}, socket}
        end

      {:deny, _limit} ->
        Logger.warn("#{player_id} game_channel ratelimit hit at cast!")

        {:stop,
         {:error,
          GameView.render("error.json", %{reason: "Slow down, rate limit exceeded. (10req/s)"})},
         socket}
    end
  end

  # Broadcast

  def broadcast_stop(game_id) do
    Logger.debug("Broadcasting game:stopped from GameChannel #{game_id}")

    TiteenipeliWeb.Endpoint.broadcast("game:#{game_id}", "game:stopped", %{})
  end

  def broadcast_player_connected(game_id, players, player) do
    Logger.debug("Broadcasting game:player_connected GameChannel #{game_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "game:#{game_id}",
      "game:player_connected",
      GameView.render("player_connected.json", players, player)
    )
  end

  def broadcast_player_disconnected(game_id, players, player) do
    Logger.debug("Broadcasting game:player_disconnected GameChannel #{game_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "game:#{game_id}",
      "game:player_disconnected",
      GameView.render("player_disconnected.json", players, player)
    )
  end

  def broadcast_npc_updated(game_id, npc) do
    TiteenipeliWeb.Endpoint.broadcast(
      "game:#{game_id}",
      "game:npc_updated",
      GameView.render("npc_updated.json", %{npc: npc})
    )
  end

  def broadcast_npc_defeated(game_id, game) do
    Logger.debug("Broadcasting game:npc_defeated GameChannel #{game_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "game:#{game_id}",
      "game:npc_defeated",
      GameView.render("npc_defeated.json", game)
    )
  end

  def broadcast_server_message(game_id, message) do
    Logger.debug("Broadcasting game:server_message GameChannel #{game_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "game:#{game_id}",
      "game:server_message",
      GameView.render("server_message.json", message)
    )
  end

  def broadcast_buff_gained(game_id, buff) do
    Logger.debug("Broadcasting game:buff_gained GameChannel #{game_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "game:#{game_id}",
      "game:buff_gained",
      GameView.render("buff.json", buff)
    )
  end

  def broadcast_buff_faded(game_id, buff) do
    Logger.debug("Broadcasting game:buff_faded GameChannel #{game_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "game:#{game_id}",
      "game:buff_faded",
      GameView.render("buff.json", buff)
    )
  end

  def broadcast_npc_damaged(game_id, damage, npc, spell, player, effect) do
    Logger.debug("Broadcasting game:damage_npc GameChannel #{game_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "game:#{game_id}",
      "game:damage_npc",
      GameView.render("damage.json", %{damage: damage, npc: npc, spell: spell, from: player, effect: effect})
    )
  end
end
