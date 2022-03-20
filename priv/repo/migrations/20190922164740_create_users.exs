defmodule Titeenipeli.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :username, :string
      add :photo_url, :string
      add :guild_id, references(:guilds, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:guild_id])
  end
end
