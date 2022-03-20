defmodule Titeenipeli.Repo.Migrations.AddGuildBuffRewards do
  use Ecto.Migration

  def change do
    alter table(:challenges) do
      remove :max_points
      add :reward_type, :string
      add :reward, :string
    end

    alter table(:solutions) do
      remove :awarded_points
    end
  end
end
