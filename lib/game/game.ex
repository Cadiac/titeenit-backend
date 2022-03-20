defmodule Titeenipeli.Game do
  @moduledoc """
  Game server
  """
  use GenServer
  require Logger

  alias Titeenipeli.Core
  alias Titeenipeli.Model.User
  alias Titeenipeli.Game.Supervisor
  alias TiteenipeliWeb.GameChannel
  alias TiteenipeliWeb.UserChannel
  alias TiteenipeliWeb.ChatChannel

  @tick 1000

  @fresh_cooldowns %{
    1 => DateTime.from_unix!(0),
    2 => DateTime.from_unix!(0),
    3 => DateTime.from_unix!(0),
    4 => DateTime.from_unix!(0),
    5 => DateTime.from_unix!(0),
    6 => DateTime.from_unix!(0),
    7 => DateTime.from_unix!(0)
  }
  @fresh_warrior_resources 0
  @fresh_mage_resources 100

  @cowking_reward_code "qZ4lCujiwhwWpirg"
  @damage_reward_code "QZ3SKB7lInGmHKVF"
  @spell_mitigation "Resist"
  @attack_mitigations ["Miss", "Dodge", "Parry", "Block"]

  @warrior_base_weapon_speed 3_500
  @hunter_base_weapon_speed 3_000

  @base_buff %{
    name: "Buff",
    damage_multiplier: 1.0,
    cooldown_multiplier: 1.0,
    crit_multiplier: 1.0,
    exp_multiplier: 1.0,
    cast_time_multiplier: 1.0,
    duration_ms: nil,
    icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_regeneration.jpg",
    id: nil,
    expires_at: nil,
    description: ""
  }

  @reward_buffs %{
    "Mark of the Wild" => %{
      @base_buff
      | name: "Mark of the Wild",
        damage_multiplier: 1.1,
        cooldown_multiplier: 0.9,
        crit_multiplier: 1.2,
        exp_multiplier: 1.1,
        cast_time_multiplier: 0.9,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_regeneration.jpg",
        id: Ecto.UUID.generate(),
        description:
          "Increases all attributes of the raid, increasing damage, crit, haste, cooldown reduction and experience gain by 10%."
    },
    "Blessing of Kings" => %{
      @base_buff
      | name: "Blessing of kings",
        damage_multiplier: 1.1,
        cooldown_multiplier: 0.9,
        crit_multiplier: 1.2,
        exp_multiplier: 1.1,
        cast_time_multiplier: 0.9,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_magic_magearmor.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases all attributes of the raid, increasing damage, crit, haste, cooldown reduction and experience gain by 10%."
    },
    "Warchief's Blessing" => %{
      @base_buff
      | name: "Warchief's Blessing",
        cooldown_multiplier: 0.8,
        cast_time_multiplier: 0.8,
        exp_multiplier: 1.1,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_arcane_teleportorgrimmar.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "20% haste to spells. 20% less cooldowns. 10% increased experience multiplier."
    },
    "Rallying Cry of the Dragonslayer" => %{
      @base_buff
      | name: "Rallying Cry of the Dragonslayer",
        damage_multiplier: 1.2,
        crit_multiplier: 2.0,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/inv_misc_head_dragon_01.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases critical chance multiplier of spells by 100% and grants 20% increased damage. 5% increased experience multiplier."
    },
    "Spirit of Zandalar" => %{
      @base_buff
      | name: "Spirit of Zandalar",
        damage_multiplier: 1.25,
        cast_time_multiplier: 0.9,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_creature_poison_05.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases casting speed by 10% and all damage by 25%. 5% increased experience multiplier."
    },
    "Sayge's Dark Fortune of Damage" => %{
      @base_buff
      | name: "Sayge's Dark Fortune of Damage",
        damage_multiplier: 1.2,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/inv_misc_orb_02.jpeg",
        id: Ecto.UUID.generate(),
        description: "Increases damage by 20%. 5% increased experience multiplier."
    },
    "Mol'dar's Moxie" => %{
      @base_buff
      | name: "Mol'dar's Moxie",
        damage_multiplier: 1.25,
        cooldown_multiplier: 0.85,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_massteleport.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Overall damage increased by 25% and cooldowns reduced by 15%. 5% increased experience multiplier."
    },
    "Fengus' Ferocity" => %{
      @base_buff
      | name: "Fengus' Ferocity",
        damage_multiplier: 1.3,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_undyingstrength.jpeg",
        id: Ecto.UUID.generate(),
        description: "Damage increased by 30%. 5% increased experience multiplier."
    },
    "Slip'kik's Savvy" => %{
      @base_buff
      | name: "Slip'kik's Savvy",
        crit_multiplier: 2.0,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_holy_lesserheal02.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Critical hit with multiplier increased by 100%. 5% increased experience multiplier."
    },
    "Increased Stamina" => %{
      @base_buff
      | name: "Increased Stamina",
        cooldown_multiplier: 0.8,
        cast_time_multiplier: 0.9,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/inv_boots_plate_03.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increased Stamina. Increases your cooldown recovery by 20% and haste by 10%. 5% increased experience multiplier."
    },
    "Rage of Ages" => %{
      @base_buff
      | name: "Rage of Ages",
        damage_multiplier: 1.25,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_strength.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases your Strength by 25, increasing your damage output by 25%. 5% increased experience multiplier."
    },
    "Strike of the Scorpok" => %{
      @base_buff
      | name: "Strike of the Scorpok",
        crit_multiplier: 2.0,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_forceofnature.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases Agility by 25, increasing your critical strike chance multiplier by 100%. 5% increased experience multiplier."
    },
    "Spirit of Boar" => %{
      @base_buff
      | name: "Spirit of Boar",
        cooldown_multiplier: 0.9,
        cast_time_multiplier: 0.8,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_purge.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases Stamina by 25, increasing your cooldown recovery by 10% and haste by 20%. 5% increased experience multiplier."
    },
    "Infallible Mind" => %{
      @base_buff
      | name: "Infallible Mind",
        damage_multiplier: 1.25,
        cast_time_multiplier: 0.8,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_ice_lament.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases Intellect by 25, increasing your haste by 20% and damage by 25%. 5% increased experience multiplier."
    },
    "Spiritual Domination" => %{
      @base_buff
      | name: "Spiritual Domination",
        damage_multiplier: 1.2,
        cooldown_multiplier: 0.9,
        cast_time_multiplier: 0.9,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_fire_incinerate.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases Spirit by 25, increasing your damage output by 20% and cooldown recovery and haste by 10%. 5% increased experience multiplier."
    },
    "Juju Might" => %{
      @base_buff
      | name: "Juju Might",
        damage_multiplier: 1.3,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/inv_misc_monsterscales_07.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases attack power, increasing your damage output by 30%. 5% increased experience multiplier."
    },
    "Juju Power" => %{
      @base_buff
      | name: "Juju Power",
        damage_multiplier: 1.3,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/inv_misc_monsterscales_11.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases Strength by 30, increasing your damage output by 30%. 5% increased experience multiplier."
    },
    "Juju Flurry" => %{
      @base_buff
      | name: "Juju Flurry",
        cooldown_multiplier: 0.8,
        cast_time_multiplier: 0.8,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/inv_misc_monsterscales_17.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases attack speed, increasing your cooldown recovery by 20% and haste by 20%. 5% increased experience multiplier."
    },
    "Juju Guile" => %{
      @base_buff
      | name: "Juju Guile",
        crit_multiplier: 2.0,
        exp_multiplier: 1.05,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/inv_misc_monsterscales_13.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Increases Intellect by 30, increasing your critical strike chance 100%. 5% increased experience multiplier."
    },
    "Sotasima" => %{
      @base_buff
      | name: "Sotasima",
        exp_multiplier: 2.0,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/inv_drink_08.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Sotasima imbues your raid with a warm and fuzzy feeling, increasing your experience gain multiplier by 100%."
    },
    "Titeenikirves" => %{
      @base_buff
      | name: "Titeenikirves",
        damage_multiplier: 2.5,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/inv_throwingaxe_05.jpeg",
        id: Ecto.UUID.generate(),
        description: "The legendary Titeenikirves increases your damage by 150%."
    },
    "Replica of Titeenikirves" => %{
      @base_buff
      | name: "Replica of Titeenikirves",
        damage_multiplier: 1.3,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/inv_throwingaxe_05.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "Replica of the legendary Titeenikirves increases your damage by 30% with its lesser effect."
    },
    "Ambulanssi" => %{
      @base_buff
      | name: "Ambulanssi",
        damage_multiplier: 2.0,
        cooldown_multiplier: 0.9,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_holy_sealofsacrifice.jpeg",
        id: Ecto.UUID.generate(),
        description:
          "The visit of an Ambulanssi replenishes the morale of your raid, increasing damage by 100% and reducing cooldowns by 10%."
    },
    "Blessing of Jukka" => %{
      @base_buff
      | name: "Blessing of Jukka",
        damage_multiplier: 1.5,
        exp_multiplier: 1.5,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/jukka.jpg",
        id: Ecto.UUID.generate(),
        description:
          "Blessing of Jukka increases your experience gain multiplier by 50%, and damage by 50%."
    },
    "Hervantapeli" => %{
      @base_buff
      | name: "Hervantapeli",
        exp_multiplier: 2.0,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/hervantapeli.jpg",
        id: Ecto.UUID.generate(),
        description:
          "After a round of Hervantapeli you feel rested, increasing your experience gain multiplier by 100%."
    },
    "Sword of a Thousand Truths" => %{
      @base_buff
      | name: "Sword of a Thousand Truths",
        damage_multiplier: 1.5,
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/swordofthousand.jpg",
        id: Ecto.UUID.generate(),
        description: "How do you kill that which has no life? Increases all damage by 50%."
    }
  }

  @spells %{
    "mage" => %{
      1 => %{
        id: 1,
        cost: 0,
        class: "mage",
        type: :attack,
        mitigation: :spell,
        name: "Fireball",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_fire_flamebolt.jpg",
        required_level: 1,
        base_damage: 20,
        variance: 0.10,
        crit_chance: 0.15,
        scaling_factor: 1.00,
        cooldown: 1_000,
        cast_time: 1_500,
        description:
          "Hurls a fiery ball that causes <%= min_damage %> to <%= max_damage %> Fire damage."
      },
      2 => %{
        id: 2,
        cost: 0,
        class: "mage",
        type: :attack,
        mitigation: :spell,
        name: "Fireblast",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_fire_fireball.jpg",
        required_level: 1,
        base_damage: 100,
        variance: 0.10,
        crit_chance: 0.15,
        scaling_factor: 2.0,
        cooldown: 8_000,
        cast_time: 0,
        description: "Blasts the enemy for <%= min_damage %> to <%= max_damage %> Fire damage."
      },
      3 => %{
        id: 3,
        cost: 0,
        class: "mage",
        type: :attack,
        mitigation: :spell,
        name: "Cone of Cold",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_frost_glacier.jpg",
        required_level: 5,
        base_damage: 150,
        variance: 0.30,
        crit_chance: 0.30,
        scaling_factor: 3.0,
        cooldown: 10_000,
        cast_time: 0,
        description:
          "Targets in a cone in front of the caster take <%= min_damage %> to <%= max_damage %> Frost damage."
      },
      4 => %{
        id: 4,
        cost: 0,
        class: "mage",
        type: :attack,
        mitigation: :spell,
        name: "Pyroblast",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_fire_fireball02.jpg",
        required_level: 10,
        base_damage: 500,
        variance: 0.50,
        crit_chance: 0.30,
        scaling_factor: 6.00,
        cooldown: 12_000,
        cast_time: 6_000,
        description:
          "Hurls an immense fiery boulder that causes <%= min_damage %> to <%= max_damage %> Fire damage"
      },
      5 => %{
        id: 5,
        cost: 0,
        class: "mage",
        type: :buff,
        name: "Arcane Power",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_lightning.jpg",
        required_level: 15,
        effect: %{
          @base_buff
          | name: "Arcane Power",
            damage_multiplier: 2.00,
            cooldown_multiplier: 0.8,
            duration_ms: 30_000,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_lightning.jpg",
            description:
              "Your spells deal 100% more damage and your cooldowns are reduced by 20%."
        },
        cooldown: 3 * 60_000,
        cast_time: 0,
        description:
          "When activated, your spells deal 100% more damage and your cooldowns are reduced by 20%. This effect lasts 30 sec."
      },
      6 => %{
        id: 6,
        cost: 0,
        class: "mage",
        type: :global_buff,
        name: "Arcane Intellect",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_holy_magicalsentry.jpg",
        required_level: 20,
        effect: %{
          @base_buff
          | name: "Arcane Intellect",
            damage_multiplier: 1.3,
            crit_multiplier: 1.2,
            duration_ms: 2 * 60_000,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_holy_magicalsentry.jpg",
            description:
              "Infuses the target's raid with brilliance, increasing their damage by 30% and critical strike chance by 20%."
        },
        cooldown: 4 * 60_000,
        cast_time: 0,
        description:
          "Infuses the target's raid with brilliance, increasing their damage and critical strike chance for 5 minutes."
      },
      7 => %{
        id: 7,
        cost: 0,
        class: "mage",
        type: :global_buff,
        name: "Time Warp",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_mage_timewarp.jpg",
        required_level: 30,
        effect: %{
          @base_buff
          | name: "Time Warp",
            cast_time_multiplier: 0.7,
            duration_ms: 40_000,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_mage_timewarp.jpg",
            description:
              "Warp the flow of time, increasing haste by 30% for all party and raid members."
        },
        cooldown: 5 * 60_000,
        cast_time: 0,
        description:
          "Warp the flow of time, increasing haste by 30% for all party and raid members for 40 sec."
      }
    },
    "warrior" => %{
      1 => %{
        id: 1,
        cost: 0,
        class: "warrior",
        type: :autoattack,
        mitigation: :physical,
        name: "Attack",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/classicon_warrior.jpeg",
        required_level: 1,
        base_damage: 25,
        variance: 0.50,
        crit_chance: 0.05,
        scaling_factor: 1.15,
        cooldown: 1_500,
        cast_time: 0,
        description:
          "Toggle auto attack, dealing <%= min_damage %> to <%= max_damage %> physical damage."
      },
      2 => %{
        id: 2,
        cost: 15,
        class: "warrior",
        type: :attack,
        mitigation: :physical,
        name: "Bloodthirst",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_bloodlust.jpg",
        required_level: 1,
        base_damage: 40,
        variance: 0.50,
        crit_chance: 0.15,
        scaling_factor: 2.00,
        cooldown: 6_000,
        cast_time: 0,
        description:
          "Cost: 15 rage. Instantly attack the target causing <%= min_damage %> to <%= max_damage %> damage."
      },
      3 => %{
        id: 3,
        cost: 25,
        class: "warrior",
        type: :attack,
        mitigation: :physical,
        name: "Whirlwind",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_whirlwind.jpeg",
        required_level: 12,
        base_damage: 100,
        variance: 0.50,
        crit_chance: 0.15,
        scaling_factor: 3.00,
        cooldown: 10_000,
        cast_time: 0,
        description:
          "Cost: 25 rage. In a whirlwind of steel you attack up to 4 enemies within 8 yards, causing <%= min_damage %> to <%= max_damage %> damage to each enemy."
      },
      4 => %{
        id: 4,
        cost: 30,
        class: "warrior",
        type: :attack,
        mitigation: :physical,
        name: "Slam",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_warrior_decisivestrike.jpeg",
        required_level: 1,
        base_damage: 30,
        variance: 0.50,
        crit_chance: 0.15,
        scaling_factor: 1.25,
        cooldown: 1_000,
        cast_time: 1_500,
        description:
          "Cost: 30 rage. Slams the opponent, causing <%= min_damage %> to <%= max_damage %> damage."
      },
      5 => %{
        id: 5,
        cost: -50,
        class: "warrior",
        type: :buff,
        name: "Bloodrage",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_racial_bloodrage.jpeg",
        required_level: 10,
        effect: %{
          @base_buff
          | name: "Bloodrage",
            duration_ms: 20_000,
            damage_multiplier: 1.2,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_racial_bloodrage.jpeg",
            description: "20% increased damage while active."
        },
        cooldown: 60_000,
        cast_time: 0,
        description:
          "Generates 50 rage at the cost of health. Damage increased by 20% while active."
      },
      6 => %{
        id: 6,
        cost: 10,
        class: "warrior",
        type: :global_buff,
        name: "Battle Shout",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_warrior_battleshout.jpeg",
        required_level: 20,
        effect: %{
          @base_buff
          | name: "Battle Shout",
            duration_ms: 120_000,
            damage_multiplier: 1.2,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_warrior_battleshout.jpeg",
            description: "All damage is increased by 20%."
        },
        cooldown: 240_000,
        cast_time: 0,
        description:
          "Cost: 10 rage. The warrior shouts, increasing damage of of all party members within 20 yards by 20%. Lasts 2 min."
      },
      7 => %{
        id: 7,
        cost: 0,
        class: "warrior",
        type: :buff,
        name: "Recklessness",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_criticalstrike.jpg",
        required_level: 30,
        effect: %{
          @base_buff
          | name: "Recklessness",
            duration_ms: 30_000,
            damage_multiplier: 1.5,
            crit_multiplier: 5.0,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_criticalstrike.jpg",
            description:
              "Most attacks will crit and and increased damage for 30 sec, but all damage taken is increased by 20%."
        },
        cooldown: 120_000,
        cast_time: 0,
        description:
          "The warrior will cause critical hits with most attacks and deal 50% increased damage for 30 sec, but all damage taken is increased by 20%."
      }
    },
    "shaman" => %{
      1 => %{
        id: 1,
        cost: 0,
        class: "shaman",
        type: :attack,
        mitigation: :spell,
        name: "Lightning Bolt",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_lightning.jpg",
        required_level: 1,
        base_damage: 20,
        variance: 0.10,
        crit_chance: 0.15,
        scaling_factor: 0.50,
        cooldown: 1_000,
        cast_time: 1_500,
        description:
          "Casts a bolt of lightning at the target for <%= min_damage %> to <%= max_damage %> Nature damage."
      },
      2 => %{
        id: 2,
        cost: 0,
        class: "shaman",
        type: :attack,
        mitigation: :spell,
        name: "Chain Lightning",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_chainlightning.jpeg",
        required_level: 1,
        base_damage: 100,
        variance: 0.10,
        crit_chance: 0.15,
        scaling_factor: 2.00,
        cooldown: 6_000,
        cast_time: 2_500,
        description:
          "Hurls a lightning bolt at the enemy, dealing <%= min_damage %> to <%= max_damage %> Nature damage and then jumping to additional nearby enemies.  Each jump reduces the damage by 30%.  Affects 3 total targets."
      },
      3 => %{
        id: 3,
        cost: 0,
        class: "shaman",
        type: :attack,
        mitigation: :spell,
        name: "Earth Shock",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_earthshock.jpeg",
        required_level: 5,
        base_damage: 130,
        variance: 0.10,
        crit_chance: 0.15,
        scaling_factor: 2.00,
        cooldown: 10_000,
        cast_time: 0,
        description:
          "Instantly shocks the target with concussive force, causing <%= min_damage %> to <%= max_damage %> Nature damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 2 sec. Causes a high amount of threat."
      },
      4 => %{
        id: 4,
        cost: 0,
        class: "shaman",
        type: :global_buff,
        mitigation: :spell,
        name: "Strength of Earth Totem",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_earthbindtotem.jpeg",
        required_level: 10,
        effect: %{
          @base_buff
          | name: "Strength of Earth Totem",
            duration_ms: 2 * 60_000,
            crit_multiplier: 1.2,
            damage_multiplier: 1.2,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_earthbindtotem.jpeg",
            description:
              "Strength of Earth Totem increases critical chance multiplier and damage of the raid by the 20% while active."
        },
        cooldown: 5 * 60_000,
        cast_time: 0,
        description:
          "Summons a Strength of Earth Totem with 5 health at the feet of the caster. The totem increases the strength of party members within 20 yards, increasing all damage by 20%. Lasts 2 min."
      },
      5 => %{
        id: 5,
        cost: 0,
        class: "shaman",
        type: :global_buff,
        name: "Windfury Totem",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_windfury.jpeg",
        required_level: 15,
        effect: %{
          @base_buff
          | name: "Windfury Totem",
            duration_ms: 2 * 60_000,
            cast_time_multiplier: 0.8,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_windfury.jpeg",
            description: "Windfury Totem increases casting and attack speed by 20%."
        },
        cooldown: 4 * 60_000,
        cast_time: 0,
        description:
          "Summons a Windfury Totem with 5 health at the feet of the caster. The totem enchants all party members main-hand weapons with wind, increasing all casting and attack speed by 20%. Lasts 2 min."
      },
      6 => %{
        id: 6,
        cost: 0,
        class: "shaman",
        type: :global_buff,
        name: "Flametongue Totem",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_guardianward.jpeg",
        required_level: 20,
        effect: %{
          @base_buff
          | name: "Flametongue Totem",
            duration_ms: 2 * 60_000,
            damage_multiplier: 1.2,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_guardianward.jpeg",
            description: "Flametongue Totem increases all damage done by 20%."
        },
        cooldown: 4 * 60_000,
        cast_time: 0,
        description:
          "Summons a Flametongue Totem that enchants all party members' weapons with fire if they are within 20 yards. Each hit causes additional 20% Fire damage. Lasts 2 min."
      },
      7 => %{
        id: 7,
        cost: 0,
        class: "shaman",
        type: :global_buff,
        name: "Bloodlust",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_bloodlust.jpg",
        required_level: 30,
        effect: %{
          @base_buff
          | name: "Bloodlust",
            cast_time_multiplier: 0.7,
            duration_ms: 40_000,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/spell_nature_bloodlust.jpg",
            description:
              "Increases melee, ranged, spell casting speed by 30% for all party members. Lasts 40 sec."
        },
        cooldown: 5 * 60_000,
        cast_time: 0,
        description:
          "Increases melee, ranged, and spell casting speed by 30% for all party members. Lasts 40 sec."
      }
    },
    "hunter" => %{
      1 => %{
        id: 1,
        cost: 0,
        class: "hunter",
        type: :autoattack,
        mitigation: :physical,
        name: "Attack",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/classicon_hunter.jpeg",
        required_level: 1,
        base_damage: 20,
        variance: 0.35,
        crit_chance: 0.15,
        scaling_factor: 1.00,
        cooldown: 1_500,
        cast_time: 0,
        description:
          "Toggle auto attack, dealing <%= min_damage %> to <%= max_damage %> physical damage."
      },
      2 => %{
        id: 2,
        cost: 40,
        class: "hunter",
        type: :attack,
        mitigation: :spell,
        name: "Arcane Shot",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_impalingbolt.jpeg",
        required_level: 1,
        base_damage: 20,
        variance: 0.25,
        crit_chance: 0.15,
        scaling_factor: 1.50,
        cooldown: 1_000,
        cast_time: 0,
        description:
          "Cost: 40 Focus. A quick shot that causes <%= min_damage %> to <%= max_damage %> Arcane damage.."
      },
      3 => %{
        id: 3,
        cost: 35,
        class: "hunter",
        type: :attack,
        mitigation: :physical,
        name: "Aimed Shot",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/inv_spear_07.jpeg",
        required_level: 12,
        base_damage: 150,
        variance: 0.10,
        crit_chance: 0.25,
        scaling_factor: 4.00,
        cooldown: 12_000,
        cast_time: 2_500,
        description:
          "Cost: 35 Focus. A powerful aimed shot that deals <%= min_damage %> to <%= max_damage %> Physical damage."
      },
      4 => %{
        id: 4,
        cost: -15,
        class: "hunter",
        type: :attack,
        mitigation: :physical,
        name: "Steady Shot",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_hunter_steadyshot.jpeg",
        required_level: 1,
        base_damage: 20,
        variance: 0.10,
        crit_chance: 0.15,
        scaling_factor: 1.25,
        cooldown: 1_000,
        cast_time: 1_750,
        description:
          "Generates 15 Focus. A steady shot that causes <%= min_damage %> to <%= max_damage %> Physical damage."
      },
      5 => %{
        id: 5,
        cost: -50,
        class: "hunter",
        type: :buff,
        name: "Hunter's Mark",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_hunter_snipershot.jpeg",
        required_level: 10,
        effect: %{
          @base_buff
          | name: "Hunter's Mark",
            duration_ms: 20_000,
            damage_multiplier: 1.2,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_hunter_snipershot.jpeg",
            description: "All damage is increased by 20%."
        },
        cooldown: 60_000,
        cast_time: 0,
        description:
          "Generates 50 Focus. Places the Hunter's Mark on the target, increasing your the Ranged Attack Power by 20%."
      },
      6 => %{
        id: 6,
        cost: 0,
        class: "hunter",
        type: :global_buff,
        name: "Trueshot Aura",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_trueshot.jpeg",
        required_level: 20,
        effect: %{
          @base_buff
          | name: "Trueshot Aura",
            duration_ms: 2 * 60_000,
            damage_multiplier: 1.2,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_trueshot.jpeg",
            description:
              "Attack power of party members within 45 yards is increased by 20% while active."
        },
        cooldown: 4 * 60_000,
        cast_time: 0,
        description:
          "Increases the attack power of party members within 45 yards by 20%. Lasts 5 min."
      },
      7 => %{
        id: 7,
        cost: 0,
        class: "hunter",
        type: :buff,
        name: "Rapid Fire",
        icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_hunter_runningshot.jpeg",
        required_level: 30,
        effect: %{
          @base_buff
          | name: "Rapid Fire",
            duration_ms: 15_000,
            cast_time_multiplier: 0.6,
            icon_url: "#{System.get_env("SERVER_URL")}/images/icons/ability_hunter_runningshot.jpeg",
            description: "Increases ranged attack speed by 40% while active."
        },
        cooldown: 2 * 60_000,
        cast_time: 0,
        description: "Increases ranged attack speed by 40% for 15 sec."
      }
    }
  }

  @derive Jason.Encoder
  defstruct id: nil,
            guild: "",
            guild_id: nil,
            zone_id: nil,
            zone: %{},
            players: %{},
            max_players: 50,
            npc: nil,
            cooldowns: %{},
            resources: %{},
            buffs: %{},
            global_buffs: [],
            combat_participants: MapSet.new(),
            attacking: Map.new(),
            last_tick: System.system_time(:millisecond),
            npc_updated: false

  def start_link(game_id) do
    GenServer.start_link(__MODULE__, game_id, name: ref(game_id))
  end

  def init(game_id) do
    Logger.info("Starting game #{game_id} with tick #{@tick}")

    Process.flag(:trap_exit, true)

    with [guild_id, zone_id] <- String.split(game_id, ":"),
         [zone] <- Core.get_zone_for_guild(guild_id, zone_id),
         guild <- Core.get_guild!(guild_id),
         reward_buffs <- Core.get_reward_buffs(guild_id) do
      Logger.debug("Game #{game_id} has reward buffs: #{inspect(reward_buffs)}")

      # Start the tick after random delay to ease the load of the server
      # by not having every channel tick simultaneously
      first_tick = Kernel.trunc(@tick + :rand.uniform() * 1_000)
      Process.send_after(self(), :tick, first_tick)

      global_buffs =
        reward_buffs
        |> Enum.map(fn buff_id -> Map.get(@reward_buffs, buff_id) end)
        |> Enum.filter(fn buff -> buff != nil end)

      {:ok,
       %__MODULE__{
         id: game_id,
         guild: guild.name,
         guild_id: guild_id,
         zone_id: zone_id,
         zone: %{
           cleared: zone.cleared,
           cleared_at: zone.cleared_at,
           unlocked: zone.unlocked,
           unlocked_at: zone.unlocked_at,
           max_level: zone.zone.max_level,
           min_level: zone.zone.min_level,
           name: zone.zone.name,
           required_kills: zone.zone.required_kills,
           current_kills: zone.current_kills,
           background_image_url: zone.zone.background_image_url,
           is_boss: zone.zone.is_boss,
           parent_zone_id: zone.zone.parent_zone_id
         },
         last_tick: System.system_time(:millisecond),
         npc:
           if(zone.zone.is_boss and zone.cleared,
             do: %{spawn_npc(zone_id, zone.zone.is_boss, 1) | hp: 0, hp_regen: 0, is_dead: true},
             else: spawn_npc(zone_id, zone.zone.is_boss, 1)
           ),
         global_buffs: global_buffs,
         combat_participants: MapSet.new(),
         npc_updated: true
       }}
    else
      _err ->
        {:stop, "Malformed game id"}
    end
  end

  defp schedule_game_tick() do
    Process.send_after(self(), :tick, @tick)
  end

  @doc """
  Called when a player joins the game
  """
  def player_connected(id, player_id, pid),
    do: try_call(id, {:player_connected, player_id, pid})

  @doc """
  Called when a player leaves the game
  """
  def player_disconnected(id, player_id), do: try_call(id, {:player_disconnected, player_id})

  @doc """
  Returns the game's state
  """
  def get_status(game_id), do: try_call(game_id, :get_status)

  @doc """
  Returns the game's state for a given player. This could hide part of the state for the player.
  """
  def get_status(game_id, player_id), do: try_call(game_id, {:get_status, player_id})

  @doc """
  Returns the list of current players.
  """
  def get_players(game_id), do: try_call(game_id, :get_players)

  @doc """
  Begin casting selected spell if its not on cooldown
  If the spell has cast time, the spell will resolve after the cast time.
  """
  def begin_cast(game_id, player_id, skill_id) do
    try_call(game_id, {:begin_cast, player_id, skill_id})
  end

  @doc """
  Resolve a spell being cast, applying its effects.
  """
  def cast_spell(game_id, player_id, skill_id) do
    try_call(game_id, {:cast_spell, player_id, skill_id})
  end

  # SERVER

  def handle_cast(
        :signal_zone_unlocked,
        %{zone: zone, guild_id: guild_id, zone_id: zone_id} = game
      ) do
    # TODO: This wasn't working during the weekend for other guilds than TiTe on the later zones.
    # I'm not sure why. Why did I even bother to get the zone from database, though?
    # This could've just toggled the unlocked flag on, there was no need to get `unlocked_at` updated.
    game =
      with [guild_zone] <- Core.get_zone_for_guild(guild_id, zone_id) do
        %{
          game
          | zone: %{zone | unlocked: guild_zone.unlocked, unlocked_at: guild_zone.unlocked_at}
        }
      else
        _ -> game
      end

    {:noreply, game}
  end

  def handle_cast({:activate_reward_buff, buff_id}, game) do
    Logger.debug("Handling :activate_reward_buff cast for #{buff_id} in game #{game.id}")
    {:noreply, activate_reward_buff(game, buff_id)}
  end

  def handle_cast(
        {:signal_reward_exp, player, is_levelup, experience_reward},
        %{players: players} = game
      ) do
    Logger.debug("Handling :signal_reward_exp cast for #{experience_reward} in game #{game.id}")

    if Map.has_key?(players, player.id) do
      {:noreply, signal_reward_exp(game, player, is_levelup, experience_reward)}
    else
      {:noreply, game}
    end
  end

  def handle_call(:get_status, _from, game), do: {:reply, game, game}

  def handle_call(
        {:get_status, player_id},
        _from,
        %{cooldowns: cooldowns, players: players, resources: resources} = game
      ) do
    Logger.debug("Handling :get_status for player #{player_id} in game #{game.id}")

    player = players |> Map.get(player_id)
    player_cooldowns = cooldowns |> Map.get(player_id)
    player_resources = resources |> Map.get(player_id)

    # Calculate numbers with non crit numbers without buffs
    buffs = %{crit_multiplier: 0.0, damage_multiplier: 1.0}

    player_spells =
      @spells
      |> Map.get(player.class)
      |> Map.values()
      |> Enum.filter(fn spell -> spell.required_level <= player.level end)
      |> Enum.map(fn spell ->
        if spell.type == :attack or spell.type == :autoattack do
          %{min_damage: min_damage, max_damage: max_damage} =
            calculate_spell_damage(buffs, spell.id, player.class, player.level)

          description =
            EEx.eval_string(spell.description,
              min_damage: min_damage,
              max_damage: max_damage
            )

          %{spell | description: description}
        else
          spell
        end
      end)

    {:reply, {game, player_cooldowns, player_spells, player_resources}, game}
  end

  def handle_call(:get_players, _from, %{players: players} = game), do: {:reply, players, game}

  def handle_call({:player_connected, player_id, _pid}, _from, game) do
    Logger.debug("Handling :player_connected for #{player_id} in game #{game.id}")

    cond do
      !game.zone.unlocked ->
        {:reply, {:error, "Zone is locked"}, game}

      Enum.count(game.players) >= game.max_players ->
        {:reply, {:error, "Game is full"}, game}

      Map.has_key?(game.players, player_id) ->
        {:reply, {:ok, self()}, game}

      true ->
        player = Core.get_user!(player_id)

        if player.class != nil do
          game = add_player(game, player)
          players = Enum.map(game.players, fn {_id, player} -> player.username || player.first_name end)

          GameChannel.broadcast_player_connected(game.id, players, player)
          {:reply, {:ok, self()}, game}
        else
          {:reply, {:error, "Select a class"}, game}
        end
    end
  end

  def handle_call({:player_disconnected, player_id}, _from, %{players: players} = game) do
    Logger.debug("Handling :player_disconnected for #{player_id} in game #{game.id}")
    player = players |> Map.get(player_id)

    if player != nil do
      case Core.update_user(player.id, %{
             level: player.level,
             experience: player.experience,
             total_experience: player.total_experience
           }) do
        {:ok, _} ->
          Logger.info("Saved disconnecting player #{player.id} progress in game #{game.id}")

        {:error, error} ->
          Logger.error(
            "Failed to save disconnecting player #{player.id} progress in game #{game.id}, reason: #{inspect(error)}"
          )
      end

      game = remove_player(game, player_id)
      players = Enum.map(game.players, fn {_id, player} -> player.username || player.first_name end)
      GameChannel.broadcast_player_disconnected(game.id, players, player)

      {:reply, {:ok, game}, game}
    else
      {:reply, {:ok, game}, game}
    end
  end

  def handle_call(
        {:begin_cast, player_id, spell_id},
        _from,
        %{cooldowns: cooldowns, players: players, attacking: attacking, resources: resources} =
          game
      ) do
    Logger.debug("Handling :begin_cast #{spell_id} for player #{player_id} in game #{game.id}")

    with player when not is_nil(player) <- Map.get(players, player_id) do
      spell = @spells |> Map.get(player.class) |> Map.get(spell_id)
      player_resources = resources |> Map.get(player_id, 0)

      cond do
        spell_id == 666 ->
          {:reply, {:error, "Buffikoodi: vYYRmTHVkpsuLLrk"}, game}

        spell == nil ->
          {:reply, {:error, "Unknown spell"}, game}

        spell.class != player.class ->
          {:reply, {:error, "The spell doesn't belong to your class"}, game}

        !check_spell_cooldown(cooldowns, spell_id, player_id) ->
          {:reply, {:error, "This spell isn't ready yet"}, game}

        spell.required_level > player.level ->
          {:reply, {:error, "You are too low level"}, game}

        spell.cost > player_resources ->
          {:reply, {:error, "You don't have enough resources to cast this spell"}, game}

        true ->
          buffs = calculate_buff_effects(game, player_id)
          player_cooldowns = cooldowns |> Map.get(player_id)

          new_cooldown =
            DateTime.add(
              DateTime.utc_now(),
              round(max(buffs.cooldown_multiplier, 0.5) * spell.cooldown),
              :millisecond
            )

          new_resources = max(min(player_resources - spell.cost, 100), 0)

          game = %{
            game
            | cooldowns:
                Map.put(cooldowns, player_id, Map.put(player_cooldowns, spell_id, new_cooldown)),
              resources: Map.put(resources, player_id, new_resources)
          }

          if new_resources != player_resources do
            UserChannel.broadcast_resources_updated(player_id, %{resources: new_resources})
          end

          if spell.type == :autoattack do
            case Map.get(attacking, player_id) do
              nil ->
                weapon_speed = class_base_weapon_speed(player.class)

                next_attack_in_ms = Kernel.trunc(weapon_speed * buffs.cast_time_multiplier)

                timer =
                  Process.send_after(
                    self(),
                    {:autoattack, player_id, spell_id},
                    next_attack_in_ms
                  )

                Logger.debug("Toggling player #{player_id} autoattack on")
                game = %{game | attacking: Map.put(attacking, player_id, timer)}

                {:reply, {:ok, %{cooldown: new_cooldown, cast_time: 0, attacking: true}}, game}

              timer ->
                Logger.debug("Toggling player #{player_id} autoattack off")
                Process.cancel_timer(timer)
                game = %{game | attacking: Map.delete(attacking, player_id)}

                {:reply, {:ok, %{cooldown: new_cooldown, cast_time: 0, attacking: false}}, game}
            end
          else
            cast_time = Kernel.trunc(buffs.cast_time_multiplier * spell.cast_time)
            Process.send_after(self(), {:cast_spell, player_id, spell_id}, cast_time)
            {:reply, {:ok, %{cooldown: new_cooldown, cast_time: cast_time}}, game}
          end
      end
    else
      _ ->
        {:reply, {:error, "Unknown player"}, game}
    end
  end

  def handle_info(
        {:autoattack, player_id, spell_id},
        %{players: players, npc: npc, resources: resources, attacking: attacking} = game
      ) do
    with player when not is_nil(player) <- Map.get(players, player_id) do
      spell = @spells |> Map.get(player.class) |> Map.get(spell_id)

      cond do
        spell == nil ->
          {:noreply, game}

        !Map.has_key?(attacking, player_id) ->
          {:noreply, game}

        npc.is_dead ->
          {:noreply, game}

        spell.type != :autoattack ->
          {:noreply, game}

        true ->
          buffs = calculate_buff_effects(game, player_id)

          game =
            cond do
              :rand.uniform() <= max(min((npc.level - player.level) * 0.01, 0.50), 0.15) ->
                GameChannel.broadcast_npc_damaged(
                  game.id,
                  nil,
                  game.npc,
                  spell,
                  player,
                  Enum.random(@attack_mitigations)
                )

                game

              true ->
                damage = calculate_spell_damage(buffs, spell_id, player.class, player.level)
                game = damage_npc(game, player_id, damage.damage)

                game =
                  if player.class == "warrior" do
                    # Generate some rage and announce the updated amount
                    player_resources = resources |> Map.get(player_id, 0)

                    average = (damage.min_damage + damage.max_damage) / 2
                    rage_gained = 25 * (damage.damage / average)

                    rage_gained =
                      if damage.is_crit do
                        round(rage_gained * 1.3)
                      else
                        round(rage_gained)
                      end

                    new_resources = max(min(player_resources + rage_gained, 100), 0)

                    UserChannel.broadcast_resources_updated(player_id, %{
                      resources: new_resources
                    })

                    %{game | resources: Map.put(resources, player_id, new_resources)}
                  else
                    game
                  end

                GameChannel.broadcast_npc_damaged(
                  game.id,
                  damage,
                  game.npc,
                  spell,
                  player,
                  nil
                )

                game
            end

          weapon_speed = class_base_weapon_speed(player.class)
          next_attack_in_ms = Kernel.trunc(weapon_speed * buffs.cast_time_multiplier)

          timer =
            Process.send_after(
              self(),
              {:autoattack, player_id, spell_id},
              next_attack_in_ms
            )

          game = %{game | attacking: Map.put(attacking, player_id, timer)}

          {:noreply, game}
      end
    else
      _ ->
        {:noreply, game}
    end
  end

  def handle_info(
        {:cast_spell, player_id, spell_id},
        %{players: players, npc: npc} = game
      ) do
    Logger.debug("Handling :begin_cast #{spell_id} for player #{player_id} in game #{game.id}")

    game =
      with player when not is_nil(player) <- Map.get(players, player_id) do
        spell = @spells |> Map.get(player.class) |> Map.get(spell_id)
        buffs = calculate_buff_effects(game, player_id)

        cond do
          spell == nil ->
            Logger.error("Unknown spell in :cast_spell #{spell_id}")
            game

          player == nil ->
            Logger.error("Unknown player in :cast_spell #{player_id}")
            game

          true ->
            cond do
              spell.type == :attack ->
                if npc.is_dead do
                  game
                else
                  cond do
                    :rand.uniform() <= 0.001 ->
                      GameChannel.broadcast_npc_damaged(
                        game.id,
                        nil,
                        game.npc,
                        spell,
                        player,
                        @damage_reward_code
                      )

                      game

                    :rand.uniform() <= max(min((npc.level - player.level) * 0.01, 0.50), 0.05) ->
                      GameChannel.broadcast_npc_damaged(
                        game.id,
                        nil,
                        game.npc,
                        spell,
                        player,
                        if spell.mitigation == :spell do
                          @spell_mitigation
                        else
                          Enum.random(@attack_mitigations)
                        end
                      )

                      game

                    true ->
                      damage = calculate_spell_damage(buffs, spell_id, player.class, player.level)
                      game = damage_npc(game, player_id, damage.damage)

                      GameChannel.broadcast_npc_damaged(
                        game.id,
                        damage,
                        game.npc,
                        spell,
                        player,
                        nil
                      )

                      game
                  end
                end

              spell.type == :global_buff ->
                activate_global_buff(game, spell.effect)

              spell.type == :buff ->
                activate_buff(game, spell.effect, player_id)
            end
        end
      else
        _ ->
          Logger.error(
            "Tried to cast spell #{spell_id} when player #{player_id} wasn't on the server"
          )

          game
      end

    {:noreply, game}
  end

  def handle_info(:tick, %{npc: npc, players: players, resources: resources} = game) do
    elapsed_ms = System.system_time(:millisecond) - game.last_tick

    # Regen life for bosses etc
    game =
      if !npc.is_dead and npc.hp_regen > 0 do
        # Regen more when the boss is low
        missing_hp_bonus_regen =
          cond do
            npc.hp / npc.max_hp < 0.10 -> 4.0
            npc.hp / npc.max_hp < 0.25 -> 2.0
            npc.hp / npc.max_hp < 0.50 -> 1.5
            true -> 1.0
          end

        regenerated_hp = round(elapsed_ms / 1000 * npc.hp_regen * missing_hp_bonus_regen)
        new_hp = min(npc.hp + regenerated_hp, npc.max_hp)

        if new_hp - npc.hp > 0 do
          Logger.debug(
            "Regenerated #{new_hp - npc.hp} hp for #{npc.name} #{npc.hp}/#{npc.max_hp} in game #{game.id}"
          )

          %{game | npc: %{npc | hp: new_hp}, npc_updated: true}
        else
          game
        end
      else
        game
      end

    # Only broadcast if updated
    if game.npc_updated do
      GameChannel.broadcast_npc_updated(game.id, game.npc)
    end

    regenerated_focus = round(elapsed_ms / 1000 * 5)

    # Grant focus to all hunter players
    resources =
      Enum.reduce(players, resources, fn {player_id, player}, acc ->
        if player.class == "hunter" do
          focus = Map.get(acc, player_id, 0)
          new_focus = min(focus + regenerated_focus, 100)

          if new_focus != focus do
            UserChannel.broadcast_resources_updated(player_id, %{
              resources: new_focus
            })
          end

          Map.put(acc, player_id, new_focus)
        else
          acc
        end
      end)

    schedule_game_tick()

    {:noreply,
     %__MODULE__{
       game
       | last_tick: System.system_time(:millisecond),
         npc_updated: false,
         resources: resources
     }}
  end

  def handle_info({:global_buff_faded, buff}, %{global_buffs: global_buffs} = game) do
    GameChannel.broadcast_buff_faded(game.id, buff)

    global_buffs = Enum.filter(global_buffs, fn b -> b.id != buff.id end)

    {:noreply, %__MODULE__{game | global_buffs: global_buffs}}
  end

  def handle_info({:buff_faded, buff, player_id}, %{buffs: buffs} = game) do
    UserChannel.broadcast_buff_faded(player_id, buff)

    player_buffs = Map.get(buffs, player_id, [])
    buffs = Map.put(buffs, player_id, Enum.filter(player_buffs, fn b -> b.id != buff.id end))

    {:noreply, %__MODULE__{game | buffs: buffs}}
  end

  def handle_info({:DOWN, _ref, :process, _pid, reason}, game) do
    Logger.error("Handling :DOWN message in game #{game.id}, reason: #{inspect(reason)}")
    persist_players(game)
    {:stop, reason, game}
  end

  def handle_info({:EXIT, _pid, reason}, game) do
    Logger.error("Handling :EXIT message in game server, reason #{inspect(reason)}")
    persist_players(game)
    {:stop, reason, game}
  end

  def handle_info(_, game), do: {:noreply, game}

  def terminate(reason, game) do
    Logger.error("Terminating game process #{game.id}, reason: #{inspect(reason)}")
    persist_players(game)
    game
  end

  def persist_players(game) do
    Logger.debug("Persisting players in game #{game.id}")

    game.players
    |> Map.values()
    |> Enum.each(fn player ->
      case Core.update_user(player.id, %{
             level: player.level,
             experience: player.experience,
             total_experience: player.total_experience
           }) do
        {:ok, _} ->
          Logger.info("Saved player #{player.id} progress in game #{game.id}")

        {:error, error} ->
          Logger.error(
            "Failed to save player #{player.id} progress in game #{game.id}, reason: #{inspect(error)}"
          )
      end
    end)
  end

  # Generates global reference
  defp ref(id), do: {:global, {:game, id}}

  defp add_player(
         %__MODULE__{
           players: players,
           cooldowns: cooldowns,
           resources: resources
         } = game,
         %User{} = user
       ) do
    default_resources =
      if user.class == "warrior" or user.class == "hunter" do
        @fresh_warrior_resources
      else
        @fresh_mage_resources
      end

    %__MODULE__{
      game
      | players: Map.put_new(players, user.id, user),
        cooldowns: Map.put_new(cooldowns, user.id, @fresh_cooldowns),
        resources: Map.put_new(resources, user.id, default_resources)
    }
  end

  defp remove_player(
         %__MODULE__{
           players: players,
           combat_participants: combat_participants,
           attacking: attacking,
           resources: resources
         } = game,
         player_id
       ) do
    attacking =
      case Map.pop(attacking, player_id) do
        {nil, attacking} ->
          attacking

        {timer, attacking} ->
          Process.cancel_timer(timer)
          attacking
      end

    %__MODULE__{
      game
      | players: Map.delete(players, player_id),
        combat_participants: MapSet.delete(combat_participants, player_id),
        attacking: attacking,
        resources: Map.delete(resources, player_id)
    }
  end

  defp damage_npc(%__MODULE__{npc: %{is_dead: true}} = game, _player_id, _damage) do
    # noop if npc is dead
    game
  end

  defp damage_npc(
         %__MODULE__{
           npc: npc,
           zone: zone,
           combat_participants: combat_participants
         } = game,
         player_id,
         damage
       ) do
    new_hp = max(npc.hp - damage, 0)

    game = %{game | combat_participants: MapSet.put(combat_participants, player_id)}

    if new_hp <= 0 do
      current_kills = zone.current_kills + 1

      game =
        if current_kills >= zone.required_kills && !zone.cleared do
          # If this is the main zone unlock its related boss zone
          if game.zone.parent_zone_id == nil do
            with {:ok, boss_zone} = Core.unlock_guild_zone_boss(game.guild_id, game.zone_id) do
              # Signal that game it has been unlocked
              Supervisor.signal_unlock_zone(game.guild_id, boss_zone.id)

              GameChannel.broadcast_server_message(
                game.id,
                %{
                  text: "The boss of #{zone.name} is now unlocked!",
                  type: "announcement"
                }
              )
            end
          else
            # The boss has been slain, let everyone know about this
            ChatChannel.broadcast_server_message(%{
              text: "#{game.guild} has slain #{npc.name} and cleared #{zone.name}!",
              type: "announcement"
            })
          end

          %{
            game
            | zone: %{
                zone
                | current_kills: zone.current_kills + 1,
                  cleared: true,
                  cleared_at: DateTime.utc_now()
              }
          }
        else
          %{game | zone: %{zone | current_kills: zone.current_kills + 1}}
        end

      Core.update_guild_zone(game.guild_id, game.zone_id, %{
        current_kills: game.zone.current_kills,
        cleared: game.zone.cleared,
        cleared_at: game.zone.cleared_at
      })

      game = %{
        game
        | npc: %{npc | hp: 0, hp_regen: 0, is_dead: true},
          npc_updated: true
      }

      # Loop through all combat participants
      rewarded_players =
        Enum.reduce(game.combat_participants, %{}, fn participant_id, acc ->
          case Map.get(game.players, participant_id) do
            nil ->
              # Player has left the game before the NPC died
              acc

            player ->
              Map.put(acc, participant_id, monster_defeated(game, player))
          end
        end)

      game = %{
        game
        | players: Map.merge(game.players, rewarded_players),
          combat_participants: MapSet.new()
      }

      # Finally spawn a new npc or leave boss dead
      if game.zone.is_boss and game.zone.cleared do
        game
      else
        new_npc = spawn_npc(game.zone_id, game.zone.is_boss, map_size(game.players))

        %{game | npc: new_npc, npc_updated: true}
      end
    else
      %{game | npc: %{npc | hp: new_hp}, npc_updated: true}
    end
  end

  defp spawn_npc(zone_id, is_boss, player_count) do
    new_base_npc = Core.random_npc(zone_id)
    new_level = new_base_npc.level

    new_max_hp =
      if is_boss do
        Kernel.trunc(new_base_npc.base_hp * :math.pow(1.10, new_level))
      else
        if new_level > 15 do
          Kernel.trunc(
            new_base_npc.base_hp * max(player_count, 1) * :math.pow(1.10, new_level)
          )
        else
          Kernel.trunc(new_base_npc.base_hp * :math.pow(1.10, new_level))
        end
      end

    Logger.debug("Spawning new npc #{new_base_npc.name}")

    new_base_npc
    |> Map.put(:max_hp, new_max_hp)
    |> Map.put(:hp, new_max_hp)
    |> Map.put(:level, new_level)
  end

  defp activate_buff(%{buffs: buffs} = game, buff, player_id) do
    buff = %{
      buff
      | expires_at: DateTime.add(DateTime.utc_now(), buff.duration_ms, :millisecond),
        id: Ecto.UUID.generate()
    }

    player_buffs = buffs |> Map.get(player_id, [])
    buffs = Map.put(buffs, player_id, [buff | player_buffs])

    game = %__MODULE__{game | buffs: buffs}

    UserChannel.broadcast_buff_gained(player_id, buff)
    Process.send_after(self(), {:buff_faded, buff, player_id}, buff.duration_ms)

    game
  end

  defp activate_global_buff(%{global_buffs: global_buffs} = game, buff) do
    buff = %{
      buff
      | expires_at: DateTime.add(DateTime.utc_now(), buff.duration_ms, :millisecond),
        id: Ecto.UUID.generate()
    }

    game = %__MODULE__{game | global_buffs: [buff | global_buffs]}

    GameChannel.broadcast_buff_gained(game.id, buff)
    Process.send_after(self(), {:global_buff_faded, buff}, buff.duration_ms)

    game
  end

  defp activate_reward_buff(%{global_buffs: global_buffs} = game, buff_id) do
    with buff when not is_nil(buff) <- Map.get(@reward_buffs, buff_id) do
      game = %__MODULE__{game | global_buffs: [buff | global_buffs]}
      GameChannel.broadcast_buff_gained(game.id, buff)
      game
    else
      _ ->
        Logger.error("Tried to activate unknown reward buff #{buff_id}")
        game
    end
  end

  defp signal_reward_exp(game, nil, _is_levleup, _experience_reward) do
    game
  end

  defp signal_reward_exp(%{players: players} = game, user, is_levelup, experience_reward) do
    if is_levelup do
      ChatChannel.broadcast_server_message(%{
        text: "#{user.username || user.first_name} has reached level #{user.level}!",
        type: "server"
      })
    end

    Logger.debug("gained #{experience_reward} experience, total #{user.total_experience}")

    UserChannel.broadcast_exp_updated(user.id, %{
      experience: user.experience,
      experience_required: Core.level_experience_required(user.level),
      experience_change: experience_reward,
      total_experience: user.total_experience,
      level: user.level,
      is_levelup: is_levelup,
      message: "Quest complete, you receive #{experience_reward} experience."
    })

    %{game | players: Map.put(players, user.id, user)}
  end

  defp calculate_buff_effects(
         %{global_buffs: global_buffs, buffs: buffs},
         player_id
       ) do
    buffs
    |> Map.get(player_id, [])
    |> Enum.concat(global_buffs)
    |> Enum.reduce(
      %{
        crit_multiplier: 1.0,
        cooldown_multiplier: 1.0,
        damage_multiplier: 1.0,
        exp_multiplier: 1.0,
        cast_time_multiplier: 1.0
      },
      fn buff, acc ->
        %{
          acc
          | crit_multiplier: acc.crit_multiplier * buff.crit_multiplier,
            cooldown_multiplier: acc.cooldown_multiplier * buff.cooldown_multiplier,
            damage_multiplier: acc.damage_multiplier * buff.damage_multiplier,
            exp_multiplier: acc.exp_multiplier * buff.exp_multiplier,
            cast_time_multiplier: acc.cast_time_multiplier * buff.cast_time_multiplier
        }
      end
    )
  end

  defp monster_defeated(
         %__MODULE__{id: game_id, npc: %{level: npc_level, name: npc_name}} = game,
         user
       ) do
    experience_reward = Core.monster_experience_by_level(npc_level)

    bonus_reward =
      cond do
        # Grant bonus if fighting higher level monsters
        user.level < npc_level ->
          Kernel.trunc(max(npc_level - user.level, 0) / 10 * experience_reward)

        # No penalty for fighting slightly lower level monsters
        user.level - npc_level <= 8 ->
          0

        # Penalty for fighting much smaller level monsters
        true ->
          Kernel.trunc(min((user.level - npc_level - 8) / 10, 1.0) * experience_reward * -1)
      end

    GameChannel.broadcast_npc_defeated(game_id, game)

    %{exp_multiplier: exp_multiplier} = calculate_buff_effects(game, user.id)
    experience_reward = Kernel.trunc((experience_reward + bonus_reward) * exp_multiplier)

    Logger.debug(
      "Granting #{user.id} exp #{experience_reward} (#{exp_multiplier} multiplier) for defeating lvl #{npc_level} #{npc_name}."
    )

    {user, is_levelup} = Core.grant_experience(user, experience_reward)

    if is_levelup do
      ChatChannel.broadcast_server_message(%{
        text: "#{user.username || user.first_name} has reached level #{user.level}!",
        type: "server"
      })
    end

    message =
      cond do
        bonus_reward > 0 ->
          "#{npc_name} dies, you gain #{experience_reward} experience. (#{bonus_reward} bonus from level)"

        bonus_reward < 0 ->
          "#{npc_name} dies, you gain #{experience_reward} experience. (#{Kernel.abs(bonus_reward)} penalty from level)"

        true ->
          "#{npc_name} dies, you gain #{experience_reward} experience."
      end

    UserChannel.broadcast_exp_updated(user.id, %{
      experience: user.experience,
      experience_required: Core.level_experience_required(user.level),
      experience_change: experience_reward,
      total_experience: user.total_experience,
      level: user.level,
      is_levelup: is_levelup,
      message: message
    })

    if npc_name == "The Cow King" do
      UserChannel.broadcast_server_message(user.id, %{
        text:
          "You have defeated the Cow King! Your guild can now enjoy Sotasima by redeeming buff code #{@cowking_reward_code} !",
        type: "announcement"
      })
    end

    user
  end

  def broadcast_unlocked_spells(user_id, user_class, level) do
    @spells
    |> Map.get(user_class)
    |> Map.values()
    |> Enum.filter(fn spell -> spell.required_level == level end)
    |> Enum.map(fn spell ->
      if spell.type == :attack do
        %{min_damage: min_damage, max_damage: max_damage} =
          calculate_spell_damage(
            %{crit_multiplier: 0.0, damage_multiplier: 1.0},
            spell.id,
            user_class,
            level
          )

        description =
          EEx.eval_string(spell.description,
            min_damage: min_damage,
            max_damage: max_damage
          )

        %{spell | description: description}
      else
        spell
      end
    end)
    |> Enum.each(fn spell ->
      UserChannel.broadcast_spell_unlocked(user_id, spell)
    end)
  end

  defp check_spell_cooldown(cooldowns, spell_id, player_id) do
    player_cooldowns = cooldowns |> Map.get(player_id)
    spell_cooldown = player_cooldowns |> Map.get(spell_id)

    DateTime.compare(spell_cooldown, DateTime.utc_now()) == :lt
  end

  def calculate_spell_damage(
        %{crit_multiplier: crit_multiplier, damage_multiplier: damage_multiplier},
        spell_id,
        class,
        player_level
      ) do
    %{
      base_damage: base_damage,
      variance: variance,
      crit_chance: crit_chance,
      scaling_factor: scaling_factor
    } = @spells |> Map.get(class) |> Map.get(spell_id)

    is_crit = :rand.uniform() <= crit_chance * crit_multiplier

    damage_multiplier = if is_crit, do: damage_multiplier * 2, else: damage_multiplier
    variance_multiplier = 1.0 + variance * :rand.uniform()
    scaled_base_damage = base_damage + 40 * (player_level - 1) * scaling_factor

    spell_damage = round(scaled_base_damage * variance_multiplier * damage_multiplier)

    %{
      damage: spell_damage,
      min_damage: round(scaled_base_damage * (1.0 - variance) * damage_multiplier),
      max_damage: round(scaled_base_damage * (1.0 + variance) * damage_multiplier),
      is_crit: is_crit
    }
  end

  defp try_call(id, message) do
    case GenServer.whereis(ref(id)) do
      nil ->
        {:error, "Game does not exist"}

      game ->
        GenServer.call(game, message)
    end
  end

  defp class_base_weapon_speed(class) do
    case class do
      "warrior" ->
        @warrior_base_weapon_speed

      "hunter" ->
        @hunter_base_weapon_speed

      _ ->
        @warrior_base_weapon_speed
    end
  end
end
