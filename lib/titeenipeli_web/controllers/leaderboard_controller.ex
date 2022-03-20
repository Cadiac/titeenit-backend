defmodule TiteenipeliWeb.LeaderboardController do
  use TiteenipeliWeb, :controller
  alias Titeenipeli.Core
  require Logger

  def by_guilds(conn, _) do
    with {:ok, res} <- Core.leaderboard_by_guilds() do
      cols = Enum.map(res.columns, &String.to_atom(&1))

      response =
        Enum.map(res.rows, fn row ->
          Enum.zip(cols, row) |> Enum.into(%{})
        end)

      conn |> json(response)
    end
  end

  def by_zones(conn, _) do
    with {:ok, res} <- Core.leaderboard_by_zones() do
      cols = Enum.map(res.columns, &String.to_atom(&1))

      response =
        Enum.map(res.rows, fn row ->
          Enum.zip(cols, row) |> Enum.into(%{})
        end)

      conn |> json(response)
    end
  end

  def by_players(conn, _) do
    players = Core.leaderboard_by_players()

    conn
    |> put_status(:ok)
    |> put_resp_header("buff-code", "thisisabuffcodepleaseredeemme")
    |> render("leaderboard_players.json", players: players)
  end
end
