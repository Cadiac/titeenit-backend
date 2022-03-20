defmodule Titeenipeli.Repo.Migrations.CreateChallenges do
  use Ecto.Migration

  def change do
    create table(:challenges) do
      add :solution, :string
      add :max_points, :integer

      timestamps()
    end
  end
end
