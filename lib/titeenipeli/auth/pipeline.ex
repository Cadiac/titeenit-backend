defmodule Titeenipeli.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :titeenipeli,
    error_handler: Titeenipeli.Auth.ErrorHandler,
    module: Titeenipeli.Auth.Guardian

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"

  plug Guardian.Plug.EnsureAuthenticated

  plug Guardian.Plug.LoadResource, allow_blank: true
end
