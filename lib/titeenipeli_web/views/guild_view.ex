defmodule TiteenipeliWeb.GuildView do
  use TiteenipeliWeb, :view
  alias TiteenipeliWeb.GuildView

  def render("index.json", %{guilds: guilds}) do
    render_many(guilds, GuildView, "guild.json")
  end

  def render("show.json", %{guild: guild}) do
    render_one(guild, GuildView, "guild.json")
  end

  def render("guild.json", %{guild: guild}) do
    %{id: guild.id, name: guild.name, logo_url: guild.logo_url}
  end
end
