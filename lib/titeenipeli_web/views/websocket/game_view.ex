defmodule TiteenipeliWeb.GameView do
  use TiteenipeliWeb, :view
  alias TiteenipeliWeb.GameView

  def render("npc.json", %{npc: npc}) do
    %{
      name: npc.name,
      max_hp: npc.max_hp,
      hp: npc.hp,
      level: npc.level,
      image_url: npc.image_url,
      is_dead: npc.is_dead
    }
  end

  def render("npc_updated.json", %{npc: npc}) do
    %{
      npc: GameView.render("npc.json", %{npc: npc})
    }
  end

  def render("npc_defeated.json", %{npc: npc, zone: zone}) do
    %{
      npc: GameView.render("npc.json", %{npc: npc}),
      zone: %{
        cleared: zone.cleared,
        cleared_at: zone.cleared_at,
        unlocked: zone.unlocked,
        unlocked_at: zone.unlocked_at,
        max_level: zone.max_level,
        min_level: zone.min_level,
        name: zone.name,
        required_kills: zone.required_kills,
        current_kills: zone.current_kills,
        background_image_url: zone.background_image_url
      }
    }
  end

  def render("server_message.json", message) do
    %{
      text: message.text,
      type: message.type
    }
  end

  def render("chat_message.json", message) do
    %{
      from: %{
        id: message.from.id,
        username: message.from.username,
        guild_id: message.from.guild_id,
        level: message.from.level
      },
      text: message.text,
      timestamp: message.timestamp,
      type: message.type
    }
  end

  def render("begin_cast.json", %{cooldown: cooldown, cast_time: cast_time, attacking: attacking}) do
    %{cooldown: cooldown, cast_time: cast_time, attacking: attacking}
  end

  def render("begin_cast.json", %{cooldown: cooldown, cast_time: cast_time}) do
    %{cooldown: cooldown, cast_time: cast_time}
  end

  def render("damage.json", %{damage: nil, npc: npc, spell: spell, from: player, effect: effect}) do
    %{
      npc: GameView.render("npc.json", %{npc: npc}),
      spell: %{
        name: spell.name,
        id: spell.id,
        type: spell.type
      },
      effect: effect,
      damage: nil,
      from: %{
        id: player.id,
        username: player.username || player.first_name
      }
    }
  end

  def render("damage.json", %{damage: damage, npc: npc, spell: spell, from: player, effect: effect}) do
    %{
      npc: GameView.render("npc.json", %{npc: npc}),
      spell: %{
        name: spell.name,
        id: spell.id,
        type: spell.type
      },
      effect: effect,
      damage: %{
        value: damage.damage,
        min_damage: damage.min_damage,
        max_damage: damage.max_damage,
        is_crit: damage.is_crit
      },
      from: %{
        id: player.id,
        username: player.username || player.first_name
      }
    }
  end

  def render("exp_updated.json", params) do
    %{
      experience: params.experience,
      experience_required: params.experience_required,
      experience_change: params.experience_change,
      total_experience: params.total_experience,
      level: params.level,
      is_levelup: params.is_levelup,
      message: params.message
    }
  end

  def render("buff.json", params) do
    %{
      id: params.id,
      name: params.name,
      damage_multiplier: params.damage_multiplier,
      cooldown_multiplier: params.cooldown_multiplier,
      crit_multiplier: params.crit_multiplier,
      duration_ms: params.duration_ms,
      expires_at: params.expires_at,
      icon_url: params.icon_url,
      description: params.description
    }
  end

  def render("spell.json", params) do
    %{
      id: params.id,
      name: params.name,
      cost: params.cost,
      cooldown: params.cooldown,
      icon_url: params.icon_url,
      required_level: params.required_level,
      cast_time: params.cast_time,
      type: params.type,
      description: params.description
    }
  end

  def render("resources.json", %{resources: resources}) do
    %{
      resources: resources
    }
  end

  def render("error.json", params) do
    %{
      reason: params.reason
    }
  end

  def render("player_connected.json", players, player) do
    %{
      id: player.id,
      username: player.username || player.first_name,
      players: players
    }
  end

  def render("player_disconnected.json", players, player) do
    %{
      id: player.id,
      username: player.username || player.first_name,
      players: players
    }
  end

  def render(
        "game_status.json",
        {
          %{npc: npc, buffs: buffs, global_buffs: global_buffs, zone: zone} = game_state,
          cooldowns,
          spells,
          resources,
        },
        player_id
      ) do
    %{
      id: game_state.id,
      guild: game_state.guild,
      guild_id: game_state.guild,
      zone_id: game_state.zone_id,
      players: Enum.map(game_state.players, fn {_id, player} -> player.username || player.first_name end),
      max_players: game_state.max_players,
      cooldowns: cooldowns,
      resources: resources,
      spells: Enum.map(spells, fn spell -> render("spell.json", spell) end),
      buffs:
        buffs
        |> Map.get(player_id, [])
        |> Enum.concat(global_buffs)
        |> Enum.map(fn buff -> render("buff.json", buff) end),
      npc: GameView.render("npc.json", %{npc: npc}),
      zone: %{
        cleared: zone.cleared,
        cleared_at: zone.cleared_at,
        unlocked: zone.unlocked,
        unlocked_at: zone.unlocked_at,
        max_level: zone.max_level,
        min_level: zone.min_level,
        name: zone.name,
        required_kills: zone.required_kills,
        current_kills: zone.current_kills,
        background_image_url: zone.background_image_url,
        is_boss: zone.is_boss,
        parent_zone_id: zone.parent_zone_id
      }
    }
  end
end
