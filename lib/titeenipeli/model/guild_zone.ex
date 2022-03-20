defmodule Titeenipeli.Model.GuildZone do
  use Ecto.Schema
  import Ecto.Changeset
  alias Titeenipeli.Model.Guild
  alias Titeenipeli.Model.Zone

  schema "guild_zones" do
    field :cleared, :boolean
    field :cleared_at, :utc_datetime
    field :unlocked, :boolean
    field :unlocked_at, :utc_datetime
    field :current_kills, :integer

    timestamps()

    belongs_to :guild, Guild
    belongs_to :zone, Zone
  end

  @doc false
  def changeset(guild_zone, attrs) do
    guild_zone
    |> cast(attrs, [
      :current_kills,
      :guild_id,
      :zone_id,
      :cleared,
      :cleared_at,
      :unlocked,
      :unlocked_at
    ])
    |> validate_required([])
  end
end
