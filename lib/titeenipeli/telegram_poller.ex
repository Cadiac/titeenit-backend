defmodule Titeenipeli.Poller do
  use GenServer
  require Logger
  alias Titeenipeli.Telegram
  alias Titeenipeli.Core

  # Server

  def start_link do
    Logger.log(:info, "[telegram] Started Telegram poller")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    get_updates()
    {:ok, 0}
  end

  def handle_cast(:get_updates, offset) do
    Logger.log(:debug, "[telegram] POST /getUpdates, offset: #{offset}")

    response = Telegram.get_updates(offset)
    latest_update_id = process_messages(response)
    {:noreply, latest_update_id + 1, 100}
  end

  def handle_info(:timeout, offset) do
    get_updates()
    {:noreply, offset}
  end

  def handle_info(:ssl_closed, offset) do
    get_updates()
    {:noreply, offset}
  end

  def handle_info({:ssl_closed, _}, offset) do
    get_updates()
    {:noreply, offset}
  end

  # Client

  def get_updates do
    GenServer.cast(__MODULE__, :get_updates)
  end

  # Message parsing

  defp process_messages({:ok, []}), do: -1

  defp process_messages({:ok, messages}) do
    messages
    |> Enum.map(fn %{:update_id => id} = message ->
      process_message(message)
      id
    end)
    |> Enum.max()
  end

  defp process_messages({:error, error}) do
    Logger.log(:error, "[telegram] Telegram API error: #{inspect(error)}")
    -1
  end

  defp parse_text(text) do
    words = String.split(text, " ", trim: true)

    case words do
      [command | params] ->
        {:ok, {command, params}}

      _ ->
        {:error, nil}
    end
  end

  defp process_message(%{message: %{chat: %{id: chat_id, type: "private"}, text: text}}) do
    Logger.log(:info, "[telegram] Message from #{chat_id}, text: #{text}")

    with {:ok, {command, params}} <- parse_text(text) do
      case command do
        "/login" ->
          Telegram.send_message(%{
            chat_id: chat_id,
            text: "Tästä sisään peliin, ei vissiin toimi web.telegram.org kautta",
            reply_markup: %{
              inline_keyboard: [
                [
                  %{
                    text: "Kirjaudu",
                    login_url: %{
                      url: "#{System.get_env("LOGIN_URL")}",
                      request_write_access: true
                    }
                  }
                ]
              ]
            }
          })

        # TODO: REMOVE THIS and related code before we hit production.
        # The reason this exists is because localhost can't be defined as the domain for tg bot logins
        # With this, a personal bot can be run, the login callback can hit the dev route on sivu.dev which redirects
        # the login back to localhost:4000/api/login/dev
        # EDIT: lol ei poistetukaan :D
        "/local" ->
          Telegram.send_message(%{
            chat_id: chat_id,
            text: "!! DEV !!: Kirjautuminen localhost:4000 bäkkäriin sivu.dev kautta",
            reply_markup: %{
              inline_keyboard: [
                [
                  %{
                    text: "Kirjaudu",
                    login_url: %{
                      url: "#{System.get_env("LOGIN_URL")}/local",
                      request_write_access: true
                    }
                  }
                ]
              ]
            }
          })

        # TODO: Same as above
        "/dev" ->
          Telegram.send_message(%{
            chat_id: chat_id,
            text:
              "!! DEV !!: Kirjautuminen sivu.dev bäkkäriin, mutta redirect localhost:3000 käyttöliittymään",
            reply_markup: %{
              inline_keyboard: [
                [
                  %{
                    text: "Kirjaudu",
                    login_url: %{
                      url: "#{System.get_env("LOGIN_URL")}/dev",
                      request_write_access: true
                    }
                  }
                ]
              ]
            }
          })

        "/redeem" ->
          {_status, reply} = Core.answer_challenge(chat_id, Enum.join(params, " "))

          Telegram.send_message(%{
            chat_id: chat_id,
            text: reply
          })

        _ ->
          nil
      end
    end
  end

  defp process_message(message),
    do: Logger.log(:debug, "[telegram] Unprocessed message #{inspect(message)}")
end
