# Titeenipeli 2022 backend

<img width="1409" alt="screenshot" src="https://user-images.githubusercontent.com/6438345/159185311-ff770c9e-3958-4e2b-ac2a-31bcd5901dd3.png">

Read the postmortem: https://docs.google.com/document/d/1Yp9LTFt-slZd7y6EQcgmbF7DzFsBGKLnxCfNW1ZZiWA/edit?usp=sharing

## Quick start

**Note**: NPC and skill/buff icon assets are not included in this repository.

To start your server:

  * Install [Elixir & Erlang](https://elixir-lang.org/install.html), tested with Elixir 1.13.3 / Erlang/OTP 24 
  * Copy `.env.sample` to `.env` and fill in the blanks, then `source .env` to set the env variables
    * Get TELEGRAM_BOT_TOKEN from @botfather
    * Generate secrets for `GUARDIAN_SECRET_KEY` and `SECRET_KEY_BASE` with `mix phx.gen.secret`
  * Start dockerized local postgresql database with `docker-compose up -d`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Fill `priv/static/images/icons` and `priv/static/images/npcs` directories with your own assets
  * Start the server with `mix phx.server` or inside IEx with `iex -S mix phx.server` for interactive shell

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Local development & logins

[Telegram login](https://core.telegram.org/widgets/login) is used to gate access to our service, so every player
links to some telegram account. The problem with this mechanism is that after login telegram redirects the login to some domain,
and this can't be configured to be localhost. Also you can't run the same bot on multiple servers simultaneously.

To solve this, the following setup exists:

- Backend is always running on api.titeenipeli.xyz with @titeenibot as its bot
- The bot running on the backend has three commands:
  - `/login`: the normal login, redirects back to /api/login on the same domain the bot that heard this was running on, and then redirects the user to REDIRECT_URI
  - ~~`/dev`: same as normal login, but redirects back to /api/login/dev which always redirects the user to UI at http://localhost:3000?token=, still creating the session on the remote dev backend that the bot runs on~~
    - NOTE: The dev server has been shut down and doesn't work anymore, and this is useless.
  - `/local`: the login callback from telegram is redirected from the server to localhost:4000, and the login session is to be created on the local backend you run

So, for the `/local` command to work and create a local session for a backend running on your machine do the following steps:
1. Register your own bot with @botfather setup your local backend to use that bot with `TELEGRAM_BOT_TOKEN`.
2. Using botfather set the bot's domain to the URL with valid SSL where you're currently hosting the frontend. For now titeenipeli.xyz can be used, that environment is configured to redirect all requests to /login/local to "http://localhost:4000/api/login".
3. Start your backend
4. Send command `/local` to your bot with telegram
5. Your local backend handles the message, and displays a login button with callback redirect to the domain you configured (titeenipeli.xyz)
6. Complete the login. GET request to titeenipeli.xyz/login/local is sent, and that site redirects the request with 301 to localhost:4000/api/login/local
7. Your local backend handles the message, creates local user and/or the session and redirects to `$REDIRECT_URI?token={token}` with the session token. By setting the REDIRECT_URI to "http://localhost:3000" you can now get local backend and UI working together.

If you're actually planning to run this locally or on a new environment contact @Cadiac on Telegram for help.

## Learn more about Phoenix
  * Official Phoenix website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
