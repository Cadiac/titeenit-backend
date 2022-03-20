defmodule Titeenipeli.Repo.Migrations.CreateSolutions do
  use Ecto.Migration

  def change do
    create table(:solutions) do
      add :challenge_id, references(:challenges, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :guild_id, references(:guilds, on_delete: :nothing)
      add :awarded_points, :integer

      timestamps()
    end

    create index(:solutions, [:challenge_id])
    create index(:solutions, [:user_id])
    create index(:solutions, [:guild_id])
    create unique_index(:solutions, [:challenge_id, :guild_id])
  end
end
