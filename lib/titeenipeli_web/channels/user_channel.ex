defmodule TiteenipeliWeb.UserChannel do
  use TiteenipeliWeb, :channel
  require Logger

  def join("user:" <> user_id, _payload, socket) do
    player_id = socket.assigns.player_id

    Logger.debug("#{player_id} is joining User channel #{user_id}")

    if user_id == "#{player_id}" do
      {:ok, socket}
    else
      Logger.error("Refused connection to user channel, user_ids: #{player_id} != #{user_id}")
      {:error, %{reason: "Refused connection, not your channel"}}
    end
  end

  # Broadcast

  def broadcast_exp_updated(user_id, experience) do
    Logger.debug("Broadcasting user:exp_updated UserChannel #{user_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "user:#{user_id}",
      "user:exp_updated",
      TiteenipeliWeb.GameView.render("exp_updated.json", experience)
    )
  end

  def broadcast_resources_updated(user_id, resources) do
    Logger.debug("Broadcasting user:resources_updated UserChannel #{user_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "user:#{user_id}",
      "user:resources_updated",
      TiteenipeliWeb.GameView.render("resources.json", resources)
    )
  end

  def broadcast_buff_gained(user_id, buff) do
    Logger.debug("Broadcasting user:buff_gained UserChannel #{user_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "user:#{user_id}",
      "user:buff_gained",
      TiteenipeliWeb.GameView.render("buff.json", buff)
    )
  end

  def broadcast_buff_faded(user_id, buff) do
    Logger.debug("Broadcasting user:buff_faded UserChannel #{user_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "user:#{user_id}",
      "user:buff_faded",
      TiteenipeliWeb.GameView.render("buff.json", buff)
    )
  end

  def broadcast_spell_unlocked(user_id, spell) do
    Logger.debug("Broadcasting user:spell_unlocked UserChannel #{user_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "user:#{user_id}",
      "user:spell_unlocked",
      TiteenipeliWeb.GameView.render("spell.json", spell)
    )
  end

  def broadcast_server_message(user_id, message) do
    Logger.debug("Broadcasting user:server_message UserChannel #{user_id}")

    TiteenipeliWeb.Endpoint.broadcast(
      "user:#{user_id}",
      "user:server_message",
      TiteenipeliWeb.GameView.render("server_message.json", message)
    )
  end
end
