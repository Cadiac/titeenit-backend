defmodule Titeenipeli.Repo.Migrations.AddCurrentKills do
  use Ecto.Migration

  def change do
    alter table(:guild_zones) do
      add :current_kills, :integer, default: 0
    end
  end
end
