defmodule Titeenipeli.Core do
  alias Titeenipeli.Repo
  import Ecto.Query

  alias Titeenipeli.Model.Guild
  alias Titeenipeli.Model.Zone
  alias Titeenipeli.Model.GuildZone
  alias Titeenipeli.Model.User
  alias Titeenipeli.Model.Npc
  alias Titeenipeli.Model.Challenge
  alias Titeenipeli.Model.Solution

  alias Titeenipeli.Game

  require Logger

  def get_user(user_id) do
    Repo.get(User, user_id)
  end

  def get_user!(user_id) do
    Repo.get!(User, user_id)
  end

  def get_user_with_guild!(user_id) do
    Repo.get!(User, user_id)
    |> Repo.preload(:guild)
  end

  def create_user!(attrs \\ %{}) do
    User.insert_changeset(%User{}, attrs) |> Repo.insert!()
  end

  def update_user(user_id, attrs \\ %{}) do
    case get_user(user_id) do
      nil ->
        {:error, :not_found}

      user ->
        User.update_changeset(user, attrs) |> Repo.update()
    end
  end

  def update_user!(user_id, attrs \\ %{}) do
    get_user!(user_id)
    |> User.update_changeset(attrs)
    |> Repo.update!()
  end

  def list_guilds() do
    Repo.all(Guild)
  end

  def get_guild!(guild_id) do
    Repo.get!(Guild, guild_id)
  end

  def get_guild(guild_id) do
    Repo.get(Guild, guild_id)
  end

  def join_guild(user_id, guild_id) do
    get_user!(user_id)
    |> User.update_changeset(%{"guild_id" => guild_id})
    |> Repo.update!()
  end

  def select_class(user_id, class) do
    get_user!(user_id)
    |> User.update_changeset(%{"class" => class})
    |> Repo.update!()
  end

  def list_zones() do
    Repo.all(Zone)
  end

  def list_zones_for_guild(guild_id) do
    Repo.all(
      from guild_zone in GuildZone,
        join: zone in assoc(guild_zone, :zone),
        where: guild_zone.guild_id == ^guild_id,
        preload: [zone: zone]
    )
  end

  def get_zone_for_guild(guild_id, zone_id) do
    Repo.all(
      from guild_zone in GuildZone,
        join: zone in assoc(guild_zone, :zone),
        where: guild_zone.guild_id == ^guild_id and guild_zone.zone_id == ^zone_id,
        preload: [zone: zone]
    )
  end

  def get_reward_buffs(guild_id) do
    Repo.all(
      from solution in Solution,
        join: challenge in assoc(solution, :challenge),
        where: solution.guild_id == ^guild_id and challenge.reward_type == "buff",
        select: challenge.reward
    )
  end

  def update_guild_zone(guild_id, zone_id, attrs \\ %{}) do
    with [guild_zone] <-
           Repo.all(
             from gz in GuildZone, where: gz.guild_id == ^guild_id and gz.zone_id == ^zone_id
           ) do
      GuildZone.changeset(guild_zone, attrs) |> Repo.update!()
    end
  end

  def unlock_guild_zone_boss(guild_id, parent_zone_id) do
    with [zone] <- Repo.all(from z in Zone, where: z.parent_zone_id == ^parent_zone_id),
         [boss_zone] <-
           Repo.all(
             from gz in GuildZone,
               where:
                 gz.guild_id == ^guild_id and gz.zone_id == ^zone.id and
                   gz.unlocked == false
           ) do
      GuildZone.changeset(boss_zone, %{unlocked: true, unlocked_at: DateTime.utc_now()})
      |> Repo.update()
    else
      _ -> {:error, :not_found}
    end
  end

  def random_npc(zone_id) do
    query =
      from npc in Npc,
        where: npc.zone_id == ^zone_id,
        order_by: fragment("RANDOM()"),
        limit: 1

    Repo.all(query) |> List.first()
  end

  def leaderboard_by_guilds() do
    Repo.query("SELECT guild_zones.guild_id, guilds.name, guilds.logo_url, json_agg(
        json_build_object(
          'zone_id', zones.id,
          'zone_name', zones.name,
          'unlocked', guild_zones.unlocked,
          'unlocked_at', guild_zones.unlocked_at,
          'cleared', guild_zones.cleared,
          'cleared_at', guild_zones.cleared_at,
          'required_kills', zones.required_kills,
          'current_kills', guild_zones.current_kills)) as progress
      FROM guild_zones
      LEFT OUTER JOIN zones ON guild_zones.zone_id = zones.id
      LEFT OUTER JOIN guilds ON guild_zones.guild_id = guilds.id
      GROUP BY guild_zones.guild_id, guilds.name, guilds.logo_url")
  end

  def leaderboard_by_zones() do
    Repo.query("SELECT guild_zones.zone_id, zones.name, json_agg(
        json_build_object(
          'guild_id', guilds.id,
          'guild_name', guilds.name,
          'unlocked', guild_zones.unlocked,
          'unlocked_at', guild_zones.unlocked_at,
          'cleared', guild_zones.cleared,
          'cleared_at', guild_zones.cleared_at,
          'required_kills', zones.required_kills,
          'current_kills', guild_zones.current_kills)) as progress
      FROM guild_zones
      LEFT OUTER JOIN zones ON guild_zones.zone_id = zones.id
      LEFT OUTER JOIN guilds ON guild_zones.guild_id = guilds.id
      GROUP BY guild_zones.zone_id, zones.name")
  end

  def leaderboard_by_players() do
    Repo.all(
      from user in User,
        select: {user, rank() |> over(order_by: [desc: user.total_experience])}
    )
  end

  def activate_reward_buff_all_zones(guild_id, buff_id) do
    Titeenipeli.Repo.all(Titeenipeli.Model.Zone)
    |> Enum.each(fn zone ->
      Titeenipeli.Game.Supervisor.activate_reward_buff(
        guild_id,
        zone.id,
        buff_id
      )
    end)
  end

  def activate_reward_exp(guild_id, user_id, experience_reward) do
    case get_user(user_id) do
      nil ->
        {:error, "Kirjaudu ensin peliin ja valitse kilta."}

      user ->
        {user, is_levelup} = grant_experience(user, experience_reward)

        Titeenipeli.Game.Supervisor.current_games()
        |> Enum.filter(fn game -> Map.has_key?(game.players, user_id) end)
        |> Enum.each(fn game ->
          Titeenipeli.Game.Supervisor.signal_reward_exp(
            guild_id,
            game.zone_id,
            user,
            is_levelup,
            experience_reward
          )
        end)

        {:ok, "Quest complete, you received #{experience_reward} experience."}
    end
  end

  def answer_challenge(_user_id, nil), do: {:error, "Anna edes joku koodi"}

  def answer_challenge(user_id, solution) do
    with %{guild_id: guild_id} = user when not is_nil(guild_id) <- get_user(user_id),
         guild when not is_nil(guild) <- get_guild(guild_id) do
      Logger.log(
        :info,
        "answer_challenge - user #{user_id} is answering with solution #{solution}"
      )

      case Repo.get_by(Challenge, %{solution: solution}) do
        nil ->
          {:error, "Väärä koodi."}

        %{id: challenge_id, reward_type: reward_type, reward: reward} ->
          case reward_type do
            "exp" ->
              case Repo.get_by(Solution, %{user_id: user_id, challenge_id: challenge_id}) do
                nil ->
                  Solution.changeset(%Solution{}, %{
                    user_id: user_id,
                    guild_id: user.guild_id,
                    challenge_id: challenge_id
                  })
                  |> Repo.insert!()

                  activate_reward_exp(user.guild_id, user_id, String.to_integer(reward || "0"))

                old_solution ->
                  if old_solution.user_id == user_id do
                    {:error,
                      "Sait jo tästä koodista expat, mutta ehkä muutkin voisivat käyttää saman koodin..."}
                  else
                    activate_reward_exp(user.guild_id, user_id, String.to_integer(reward || "0"))
                  end
              end

            "buff" ->
              case Repo.get_by(Solution, %{challenge_id: challenge_id, guild_id: guild_id}) do
                nil ->
                  Solution.changeset(%Solution{}, %{
                    user_id: user_id,
                    guild_id: user.guild_id,
                    challenge_id: challenge_id
                  })
                  |> Repo.insert!()

                  activate_reward_buff_all_zones(user.guild_id, reward)

                  TiteenipeliWeb.ChatChannel.broadcast_server_message(%{
                    text:
                      "#{user.username || user.first_name} unlocked buff \"#{reward}\" for #{guild.name}!",
                    type: "announcement"
                  })

                  {:ok, "Löysitte koodin ja koko kiltanne sai pysyvän buffin."}

                _old_solution ->
                  {:error, "Kiltasi on jo saanut buffin jonka tämä koodi antaa."}
              end

            _ ->
              {:error,
               "Virheellinen palkinto, pistäkääs viestiä @Cadiac telegramissa niin saatte jotain."}
          end
      end
    else
      _ -> {:error, "Rekisteröidy ja liity kiltaan."}
    end
  end

  def grant_experience(user, experience_reward) do
    level_xp_required = level_experience_required(user.level)
    player_xp_required = level_xp_required - user.experience
    total_experience = user.total_experience + experience_reward

    Logger.debug(
      "Player #{user.id}: lvl #{user.level} exp #{user.experience} / #{level_xp_required}."
    )

    Logger.debug("Granting #{user.id} reward of #{experience_reward} experience.")

    if player_xp_required <= experience_reward do
      user = level_up(user, experience_reward)

      user =
        update_user!(user.id, %{
          level: user.level,
          experience: user.experience,
          total_experience: total_experience
        })

      {user, true}
    else
      user =
        update_user!(user.id, %{
          experience: user.experience + experience_reward,
          total_experience: total_experience
        })

      {user, false}
    end
  end

  defp level_up(user, experience_reward) do
    level_xp_required = level_experience_required(user.level)
    player_xp_required = level_xp_required - user.experience

    level = user.level + 1
    remaining_reward = experience_reward - player_xp_required

    Logger.info("Player #{user.id} is now level #{level}.")

    # Broadcast any spells this level unlocked to user channel
    Game.broadcast_unlocked_spells(user.id, user.class, level)

    if remaining_reward >= level_experience_required(level) do
      level_up(%{user | level: level, experience: 0}, remaining_reward)
    else
      %{user | level: level, experience: remaining_reward}
    end
  end

  def monster_experience_by_level(level), do: 45 + 5 * level

  def level_experience_required(current_level) do
    # Vanilla WoW experience scaling formula:
    # XP = ((8 × CL) + Diff(CL)) × MXP(CL)
    # where CL = the current Character Level
    diff =
      cond do
        current_level <= 28 -> 0
        current_level == 29 -> 1
        current_level == 30 -> 3
        current_level == 31 -> 6
        current_level >= 32 -> 5 * (current_level - 30)
      end

    monster_xp = 45 + 5 * current_level

    (8 * current_level + diff) * monster_xp
  end
end
