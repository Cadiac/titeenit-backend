defmodule Titeenipeli.Model.Guild do
  use Ecto.Schema
  import Ecto.Changeset
  alias Titeenipeli.Model.User
  alias Titeenipeli.Model.Solution

  schema "guilds" do
    field :logo_url, :string
    field :name, :string

    timestamps()

    has_many :users, User, foreign_key: :guild_id
    has_many :solutions, Solution, foreign_key: :guild_id
  end

  @doc false
  def changeset(guild, attrs) do
    guild
    |> cast(attrs, [:id, :name, :logo_url])
    |> validate_required([:id, :name, :logo_url])
  end
end
