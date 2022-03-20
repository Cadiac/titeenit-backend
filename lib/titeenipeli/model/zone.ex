defmodule Titeenipeli.Model.Zone do
  use Ecto.Schema
  alias Titeenipeli.Model.Zone
  alias Titeenipeli.Model.GuildZone

  schema "zones" do
    field :name, :string
    field :min_level, :integer
    field :max_level, :integer
    field :background_image_url, :string
    field :required_kills, :integer
    field :is_boss, :boolean

    timestamps()

    belongs_to :parent, Zone, foreign_key: :parent_zone_id
    has_many :guild_zones, GuildZone, foreign_key: :zone_id
  end
end
