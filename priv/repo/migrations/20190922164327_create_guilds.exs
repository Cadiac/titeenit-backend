defmodule Titeenipeli.Repo.Migrations.CreateGuilds do
  use Ecto.Migration

  def change do
    create table(:guilds) do
      add :name, :string
      add :logo_url, :string

      timestamps()
    end
  end
end
