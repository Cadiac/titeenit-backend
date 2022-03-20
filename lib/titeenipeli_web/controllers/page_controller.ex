defmodule TiteenipeliWeb.PageController do
  use TiteenipeliWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(200)
    |> put_resp_header("buff-code", "thisisabuffcodepleaseredeemme")
    |> render("index.json")
  end
end
