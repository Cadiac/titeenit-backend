defmodule TiteenipeliWeb.ZoneController do
  use TiteenipeliWeb, :controller
  alias Titeenipeli.Core

  def index(conn, _) do
    case Guardian.Plug.current_resource(conn) do
      %{guild_id: nil} ->
        conn
        |> put_status(403)
        |> put_resp_header("buff-code", "thisisabuffcodepleaseredeemme")
        |> json(%{reason: "You need to join a guild first"})

      %{guild_id: guild_id} ->
        guild_zones = Core.list_zones_for_guild(guild_id)

        conn
        |> put_status(:ok)
        |> put_resp_header("buff-code", "thisisabuffcodepleaseredeemme")
        |> render("index.json", zones: guild_zones)
    end
  end
end
