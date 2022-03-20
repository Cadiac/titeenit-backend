defmodule TiteenipeliWeb.SessionController do
  use TiteenipeliWeb, :controller
  require Logger
  alias Titeenipeli.Auth.Guardian
  alias Titeenipeli.Core

  @bot_token System.get_env("TELEGRAM_BOT_TOKEN")
  @hashed_bot_token :crypto.hash(:sha256, @bot_token)

  def login(conn, %{"id" => user_id} = params) do
    check_hash = Map.get(params, "hash")

    check_string =
      params
      |> Map.delete("hash")
      |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
      |> Enum.join("\n")

    calculated_hash =
      :crypto.mac(:hmac, :sha256, @hashed_bot_token, check_string)
      |> Base.encode16()
      |> String.downcase()

    Logger.debug("Comparing calculated hash #{calculated_hash} to #{check_hash}")

    if check_hash == calculated_hash do
      user =
        case Core.get_user(user_id) do
          # User not found, build new from params
          nil -> Core.create_user!(params)
          # User exists, update user data and use it
          _user -> Core.update_user!(user_id, params)
        end

      {:ok, token, _} =
        Guardian.encode_and_sign(
          user,
          %{titeeni_buff: "iF63oghHuGD9ZaEB", next_puzzle: "https://ettubrute.netlify.app/"},
          token_type: :access
        )

      conn
      |> put_req_header("authorization", "bearer: " <> token)
      |> put_status(301)
      |> redirect(external: "#{System.get_env("REDIRECT_URI")}?token=#{token}")
    else
      conn
      |> put_status(401)
      |> json(%{success: false, token: nil})
    end
  end

  def profile(conn, _) do
    with %{id: user_id} <- Guardian.Plug.current_resource(conn) do
      user = Core.get_user_with_guild!(user_id)

      guild =
        if user.guild do
          %{
            id: user.guild.id,
            name: user.guild.name,
            logo_url: user.guild.logo_url
          }
        end

      conn
      |> put_status(:ok)
      |> json(%{
        id: user.id,
        username: user.username || user.first_name,
        first_name: user.first_name,
        last_name: user.last_name,
        photo_url: user.photo_url,
        guild: guild,
        level: user.level,
        class: user.class,
        experience: user.experience,
        experience_required: Core.level_experience_required(user.level),
        total_experience: user.total_experience
      })
    end
  end

  def classes(conn, _) do
    conn
    |> put_status(:ok)
    |> json([
      %{
        id: "mage",
        name: "Mage",
        icon: "#{System.get_env("SERVER_URL")}/images/icons/classicon_mage.jpeg"
      },
      %{
        id: "warrior",
        name: "Warrior",
        icon: "#{System.get_env("SERVER_URL")}/images/icons/classicon_warrior.jpeg"
      },
      %{
        id: "shaman",
        name: "Shaman",
        icon: "#{System.get_env("SERVER_URL")}/images/icons/classicon_shaman.jpeg"
      },
      %{
        id: "hunter",
        name: "Hunter",
        icon: "#{System.get_env("SERVER_URL")}/images/icons/classicon_hunter.jpeg"
      }
    ])
  end

  # NOTE: User can change their class with this :D
  def select_class(conn, %{"class" => class}) do
    current_user = Guardian.Plug.current_resource(conn)
    Core.select_class(current_user.id, class)

    conn
    |> put_status(:ok)
    |> json(%{success: true})
  end

  # TODO: remove these endpoints
  # Logs in the user to remote backend and redirects to local UI
  def dev(conn, %{"id" => user_id} = params) do
    check_hash = Map.get(params, "hash")

    check_string =
      params
      |> Map.delete("hash")
      |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
      |> Enum.join("\n")

    calculated_hash =
      :crypto.mac(:hmac, :sha256, @hashed_bot_token, check_string)
      |> Base.encode16()
      |> String.downcase()

    Logger.debug("Comparing calculated hash #{calculated_hash} to #{check_hash}")

    if check_hash == calculated_hash do
      user =
        case Core.get_user(user_id) do
          # User not found, build new from params
          nil -> Core.create_user!(params)
          # User exists, just use it
          user -> user
        end

      {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)

      conn
      |> put_req_header("authorization", "bearer: " <> token)
      |> put_status(301)
      |> redirect(external: "http://localhost:3000?token=#{token}")
    else
      conn
      |> put_status(401)
      |> json(%{success: false, token: nil})
    end
  end

  # Redirects the login to local backend
  def local(conn, params) do
    qs = params |> Enum.map(fn {k, v} -> "#{k}=#{v}" end) |> Enum.join("&")

    conn
    |> put_status(301)
    |> redirect(external: "http://localhost:4000/api/login?#{qs}")
  end
end
