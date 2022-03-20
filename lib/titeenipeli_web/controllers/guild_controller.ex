defmodule TiteenipeliWeb.GuildController do
  use TiteenipeliWeb, :controller
  alias Titeenipeli.Core
  require Logger

  def index(conn, _) do
    guilds = Core.list_guilds()
    render(conn, "index.json", guilds: guilds)
  end

  # NOTE: User can change guilds with this :D
  def join_guild(conn, %{"guild_id" => guild_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    Core.join_guild(current_user.id, guild_id)

    conn
    |> put_status(:created)
    |> put_resp_header("buff-code", "thisisabuffcodepleaseredeemme")
    |> json(%{success: true})
  end
end
