defmodule TiteenipeliWeb.Router do
  use TiteenipeliWeb, :router

  pipeline :auth do
    plug Titeenipeli.Auth.Pipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TiteenipeliWeb do
    pipe_through :api

    get "/", PageController, :index
  end

  # Public routes
  scope "/api", TiteenipeliWeb do
    pipe_through :api

    get "/login", SessionController, :login
    get "/login/local", SessionController, :local # TODO: Remove this
    get "/login/dev", SessionController, :dev # TODO: Remove this

    get "/guilds", GuildController, :index
    get "/classes", SessionController, :classes
    get "/leaderboard/guilds", LeaderboardController, :by_guilds
    get "/leaderboard/zones", LeaderboardController, :by_zones
    get "/leaderboard/players", LeaderboardController, :by_players
  end

  # Authenticated routes
  scope "/api", TiteenipeliWeb do
    pipe_through [:api, :auth]

    get "/profile", SessionController, :profile
    post "/classes/join", SessionController, :select_class
    post "/guilds/join", GuildController, :join_guild
    get "/zones", ZoneController, :index
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TiteenipeliWeb.Telemetry
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", TiteenipeliWeb do
  #   pipe_through :api
  # end
end
