defmodule Titeenipeli.Model.Npc do
  use Ecto.Schema
  import Ecto.Changeset
  alias Titeenipeli.Model.Zone

  schema "npcs" do
    field :base_hp, :integer
    field :image_url, :string
    field :level, :integer
    field :name, :string
    field :hp_regen, :integer
    field :is_dead, :boolean, virtual: true, default: false

    belongs_to :zone, Zone

    timestamps()
  end

  @doc false
  def changeset(npc, attrs) do
    npc
    |> cast(attrs, [:name, :image_url, :base_hp, :level, :hp_regen])
    |> validate_required([:name, :image_url, :base_hp, :level, :hp_regen])
  end
end
