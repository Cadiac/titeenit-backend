defmodule Titeenipeli.Model.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Titeenipeli.Model.Guild
  alias Titeenipeli.Model.Solution

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :photo_url, :string
    field :username, :string
    field :class, :string
    field :level, :integer, default: 1
    field :experience, :integer, default: 0
    field :total_experience, :integer, default: 0
    field :is_banned, :boolean

    timestamps()

    belongs_to :guild, Guild
    has_many :solutions, Solution, foreign_key: :user_id
  end

  @doc false
  def insert_changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :first_name, :last_name, :username, :photo_url])
    |> validate_required([:id])
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :first_name,
      :last_name,
      :username,
      :photo_url,
      :guild_id,
      :class,
      :level,
      :experience,
      :total_experience
    ])
    |> validate_inclusion(:class, ["mage", "warrior", "hunter", "shaman"])
    |> validate_number(:level, greater_than_or_equal_to: user.level)
    |> validate_number(:total_experience, greater_than_or_equal_to: user.total_experience)
  end
end
