defmodule Titeenipeli.Repo.Migrations.AddBossZoneFlag do
  use Ecto.Migration

  def change do
    alter table(:zones) do
      add :is_boss, :boolean, default: false
      add :parent_zone_id, references(:zones, on_delete: :nothing)
    end
  end
end
