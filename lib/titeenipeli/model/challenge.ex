defmodule Titeenipeli.Model.Challenge do
  use Ecto.Schema
  import Ecto.Changeset

  alias Titeenipeli.Model.Solution

  schema "challenges" do
    field :solution, :string
    field :reward_type, :string
    field :reward, :string

    timestamps()

    has_many :solutions, Solution, foreign_key: :challenge_id
  end

  @doc false
  def changeset(challenge, attrs) do
    challenge
    |> cast(attrs, [:solution, :reward_type, :reward])
    |> validate_required([:solution, :reward_type, :reward])
  end
end
