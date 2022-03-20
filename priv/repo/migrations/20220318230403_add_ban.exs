defmodule Titeenipeli.Repo.Migrations.AddBan do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_banned, :boolean
    end
  end
end
