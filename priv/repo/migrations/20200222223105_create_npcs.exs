defmodule Titeenipeli.Repo.Migrations.CreateNpcs do
  use Ecto.Migration

  def change do
    create table(:npcs) do
      add :name, :string
      add :image_url, :string
      add :max_hp, :integer
      add :hp, :integer
      add :level, :integer

      timestamps()
    end
  end
end
