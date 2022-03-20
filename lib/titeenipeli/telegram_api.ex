defmodule Titeenipeli.Telegram do
  @bot_token System.get_env("TELEGRAM_BOT_TOKEN")

  defp send_request(method, body) do
    HTTPoison.request(
      :post,
      "https://api.telegram.org/bot#{@bot_token}/#{method}",
      body,
      [{"Content-Type", "application/json"}],
      recv_timeout: 15000
    )
  end

  defp process_response(response, _method) do
    case decode_response(response) do
      {:ok, true} -> :ok
      {:ok, %{ok: false, description: description}} -> {:error, %{reason: inspect(description)}}
      {:ok, result} -> {:ok, result}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, %{reason: inspect(reason)}}
      {:error, error} -> {:error, %{reason: inspect(error)}}
    end
  end

  defp decode_response(response) do
    with {:ok, %HTTPoison.Response{body: body}} <- response,
         {:ok, %{result: result}} <- Jason.decode(body, keys: :atoms),
         do: {:ok, result}
  end

  def get_updates(offset) do
    body = Jason.encode!(%{offset: offset, timeout: 10})

    send_request("getUpdates", body)
    |> process_response("getUpdates")
  end

  def send_message(%{chat_id: _, text: _} = body) do
    send_request("sendMessage", Jason.encode!(body))
    |> process_response("sendMessage")
  end
end
