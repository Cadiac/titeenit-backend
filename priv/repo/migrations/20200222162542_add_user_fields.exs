defmodule Titeenipeli.Repo.Migrations.AddUserFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :level, :integer, default: 1
      add :total_experience, :integer, default: 0
      add :experience, :integer, default: 0
    end
  end
end
