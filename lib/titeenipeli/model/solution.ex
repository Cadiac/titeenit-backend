defmodule Titeenipeli.Model.Solution do
  use Ecto.Schema
  import Ecto.Changeset
  alias Titeenipeli.Model.Guild
  alias Titeenipeli.Model.Challenge
  alias Titeenipeli.Model.User

  schema "solutions" do
    timestamps()

    belongs_to :guild, Guild
    belongs_to :challenge, Challenge
    belongs_to :user, User
  end

  @doc false
  def changeset(solution, attrs) do
    solution
    |> cast(attrs, [:guild_id, :challenge_id, :user_id])
    |> unique_constraint([:guild_id, :challenge_id, :user_id], name: :solutions_challenge_id_guild_id_user_id_index)
    |> validate_required([])
  end
end
