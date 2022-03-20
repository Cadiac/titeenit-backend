defmodule TiteenipeliWeb.ZoneView do
  use TiteenipeliWeb, :view
  alias TiteenipeliWeb.ZoneView

  def render("index.json", %{zones: guild_zones}) do
    render_many(guild_zones, ZoneView, "guild_zone.json")
  end

  def render("guild_zone.json", %{zone: guild_zone}) do
    %{
      id: guild_zone.zone.id,
      name: guild_zone.zone.name,
      background_image_url: guild_zone.zone.background_image_url,
      min_level: guild_zone.zone.min_level,
      max_level: guild_zone.zone.max_level,
      required_kills: guild_zone.zone.required_kills,
      current_kills: guild_zone.current_kills,
      cleared: guild_zone.cleared,
      cleared_at: guild_zone.cleared_at,
      unlocked: guild_zone.unlocked,
      unlocked_at: guild_zone.unlocked_at,
      is_boss: guild_zone.zone.is_boss,
      parent_zone_id: guild_zone.zone.parent_zone_id
    }
  end
end
