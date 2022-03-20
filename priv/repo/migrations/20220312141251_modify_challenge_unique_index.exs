defmodule Titeenipeli.Repo.Migrations.ModifyChallengeUniqueIndex do
  use Ecto.Migration

  def change do
    drop index(:solutions, [:challenge_id, :guild_id])
    create unique_index(:solutions, [:challenge_id, :guild_id, :user_id])
  end
end
