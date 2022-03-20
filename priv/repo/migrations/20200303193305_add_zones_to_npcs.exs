defmodule Titeenipeli.Repo.Migrations.AddZonesToNpcs do
  use Ecto.Migration

  def change do
    alter table(:npcs) do
      add :zone_id, references(:zones, on_delete: :nothing)
    end
  end
end
