defmodule TiteenipeliWeb.PageView do
  use TiteenipeliWeb, :view

  def render("index.json", _) do
    %{title: "Halo?",
      message: "This is the backend of Titeenipeli 2022. Be nice and don't try to crash this server - it won't do any good for your guild's success.",
      tip: "Instead keep your eyes open and try to find all the powerups we've hidden accross the internet and Hervanta. Here's one for free, message @titeenibot '/redeem TxysgcNM0TUyCAEl' for a permanent buff."}
  end
end
