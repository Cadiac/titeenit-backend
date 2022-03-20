defmodule TiteenipeliWeb.LeaderboardView do
  use TiteenipeliWeb, :view
  alias TiteenipeliWeb.LeaderboardView

  def render("leaderboard_players.json", %{players: players}) do
    render_many(players, LeaderboardView, "player.json")
  end

  def render("player.json", %{leaderboard: {player, rank}}) do
    %{
      id: player.id,
      username: player.username || player.first_name,
      first_name: player.first_name,
      last_name: player.last_name,
      photo_url: player.photo_url,
      guild_id: player.guild_id,
      level: player.level,
      total_experience: player.total_experience,
      experience: player.experience,
      rank: rank
    }
  end
end
