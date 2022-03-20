defmodule Titeenipeli.Repo.Migrations.AddNpcDefences do
  use Ecto.Migration

  def change do
    rename table(:npcs), :hp, to: :base_hp

    alter table(:npcs) do
      remove :max_hp
      add :hp_regen, :integer, default: 0
    end
  end
end
