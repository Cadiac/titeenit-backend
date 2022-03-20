defmodule Titeenipeli.Repo.Migrations.AddZones do
  use Ecto.Migration

  def change do
    create table(:zones) do
      add :name, :string
      add :min_level, :integer
      add :max_level, :integer
      add :background_image_url, :string
      add :required_kills, :integer, default: 1

      timestamps()
    end

    create table(:guild_zones) do
      add :guild_id, references(:guilds, on_delete: :nothing)
      add :zone_id, references(:zones, on_delete: :nothing)
      add :unlocked, :boolean, default: false
      add :cleared, :boolean, default: false
      add :cleared_at, :utc_datetime
      add :unlocked_at, :utc_datetime

      timestamps()
    end
  end
end
