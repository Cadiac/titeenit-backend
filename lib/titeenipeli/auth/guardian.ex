defmodule Titeenipeli.Auth.Guardian do
  use Guardian, otp_app: :titeenipeli
  alias Titeenipeli.Core

  def subject_for_token(user, _claims) do
    {:ok, user.id}
  end

  def resource_from_claims(claims) do
    user_id = claims["sub"]
    user = Core.get_user!(user_id)

    {:ok, %{id: user_id, username: user.username || user.first_name, guild_id: user.guild_id}}
  end
end
