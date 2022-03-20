defmodule TiteenipeliWeb.ChatChannel do
  use TiteenipeliWeb, :channel
  alias Titeenipeli.Core

  require Logger

  def join("chat:global", _payload, socket) do
    player_id = socket.assigns.player_id

    %{is_banned: is_banned} = Core.get_user!(player_id)

    if is_banned do
      {:error, %{reason: "Banned."}}
    else
      Logger.debug("#{player_id} is joining Chat channel global")
      {:ok, socket}
    end
  end

  # Commands

  def handle_in("chat:send_global_message", %{"text" => text}, socket) when is_binary(text) do
    player_id = socket.assigns.player_id
    player = Core.get_user!(player_id)
    kekbur = ~r/\blol\b/i

    case Hammer.check_rate("send_global_message:#{player_id}", 10_000, 10) do
      {:allow, _count} ->
        if String.length(text) > 255 do
          Logger.warn("#{player_id} chat:send_global_message ignored too long chat message")
        else
          broadcast_global_chat_message(%{
            from: %{
              id: player_id,
              username: player.username || player.first_name,
              guild_id: player.guild_id,
              level: player.level
            },
            text: text |> String.replace(kekbur, Enum.random(["kek", "bur"])),
            timestamp: DateTime.utc_now(),
            type: "chat"
          })
        end

      {:deny, _limit} ->
        Logger.warn("#{player_id} chat:send_global_message ratelimit hit!")
    end

    {:noreply, socket}
  end

  # Broadcast

  def broadcast_server_message(message) do
    Logger.debug("Broadcasting chat:server_message ChatChannel global")

    TiteenipeliWeb.Endpoint.broadcast(
      "chat:global",
      "chat:server_message",
      TiteenipeliWeb.GameView.render("server_message.json", message)
    )
  end

  def broadcast_global_chat_message(message) do
    Logger.debug("Broadcasting chat:chat_message ChatChannel global")

    TiteenipeliWeb.Endpoint.broadcast(
      "chat:global",
      "chat:chat_message",
      TiteenipeliWeb.GameView.render("chat_message.json", message)
    )
  end
end
