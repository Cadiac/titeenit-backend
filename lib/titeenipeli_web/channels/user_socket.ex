defmodule TiteenipeliWeb.UserSocket do
  use Phoenix.Socket
  require Logger

  ## Channels
  channel("game:*", TiteenipeliWeb.GameChannel)
  channel("user:*", TiteenipeliWeb.UserChannel)
  channel("chat:global", TiteenipeliWeb.ChatChannel)

  def connect(%{"token" => token}, socket, _connect_info) when is_binary(token) do
    # Do token check here and if ok assign player_id
    case Guardian.Phoenix.Socket.authenticate(socket, Titeenipeli.Auth.Guardian, token) do
      {:ok, authed_socket} ->
        with %{id: player_id, username: username} <-
               Guardian.Phoenix.Socket.current_resource(authed_socket) do
          {:ok,
           socket
           |> assign(:player_id, player_id)
           |> assign(:username, username)}
        end

      {:error, reason} ->
        Logger.error("Refused connection for token #{token} - #{inspect(reason)}")
        :error
    end
  end

  # This function is be called when there was no token information
  def connect(_params, _socket, _connect_info) do
    Logger.error("Refused connection, no token")
    :error
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     TiteenipeliWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  # def id(_socket), do: nil
  def id(socket), do: "user_socket:#{socket.assigns.player_id}"
end
