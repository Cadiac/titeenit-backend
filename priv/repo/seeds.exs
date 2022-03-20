# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Titeenipeli.Repo.insert!(%Titeenipeli.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto.Query

# Guilds
Titeenipeli.Repo.insert!(%Titeenipeli.Model.Guild{
  name: "TiTe",
  logo_url: "#{System.get_env("SERVER_URL")}/images/guilds/tite.png"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Guild{
  name: "OTiT",
  logo_url: "#{System.get_env("SERVER_URL")}/images/guilds/otit.jpg"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Guild{
  name: "Digit",
  logo_url: "#{System.get_env("SERVER_URL")}/images/guilds/digit.svg"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Guild{
  name: "TiK",
  logo_url: "#{System.get_env("SERVER_URL")}/images/guilds/tik.png"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Guild{
  name: "Cluster",
  logo_url: "#{System.get_env("SERVER_URL")}/images/guilds/cluster.png"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "sn6KKCzvkGxeCko5",
  reward_type: "buff",
  reward: "Warchief's Blessing"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "TOP6Keu0yHkEMC6k",
  reward_type: "buff",
  reward: "Rallying Cry of the Dragonslayer"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "PvgQbMPo6bXHukM0",
  reward_type: "buff",
  reward: "Spirit of Zandalar"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "4AKQOZhCP3WbLMpu",
  reward_type: "buff",
  reward: "Sayge's Dark Fortune of Damage"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "YN4U9q5nWRsq6ZFt",
  reward_type: "buff",
  reward: "Mol'dar's Moxie"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "HNKRh5dn0cAb0sRP",
  reward_type: "buff",
  reward: "Fengus' Ferocity"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "3q143ia5648xW1Sq",
  reward_type: "buff",
  reward: "Slip'kik's Savvy"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "IxU1khlkLg9W2dk9",
  reward_type: "buff",
  reward: "Increased Stamina"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "sPC/7rxv3DWp7d8R",
  reward_type: "buff",
  reward: "Rage of Ages"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "5zhrT7qVS+LooAHc",
  reward_type: "buff",
  reward: "Strike of the Scorpok"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "QZ3SKB7lInGmHKVF",
  reward_type: "buff",
  reward: "Spirit of Boar"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "RGm10jvGeJheLrxP",
  reward_type: "buff",
  reward: "Infallible Mind"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "30A/uuMISi2Kj1h0",
  reward_type: "buff",
  reward: "Spiritual Domination"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "TxysgcNM0TUyCAEl",
  reward_type: "buff",
  reward: "Juju Might"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "HQE8qsYutnHBjWfX",
  reward_type: "buff",
  reward: "Juju Power"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "n0m+xituBO1xVJHx",
  reward_type: "buff",
  reward: "Juju Flurry"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "YapofORuD3mwJiXs",
  reward_type: "buff",
  reward: "Juju Guile"
})

# High tier buffs
Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "4Q6f6JbtYMChclEZ",
  reward_type: "buff",
  reward: "Hervantapeli"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "qZ4lCujiwhwWpirg",
  reward_type: "buff",
  reward: "Sotasima"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "legendaarinentiteenikirves",
  reward_type: "buff",
  reward: "Titeenikirves"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "f1jhXXOYYaU1KkLc",
  reward_type: "buff",
  reward: "Replica of Titeenikirves"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "NK8Z4GIFGZVUAPBS",
  reward_type: "buff",
  reward: "Blessing of Jukka"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "UAFUCWKNH5KSGJ21",
  reward_type: "buff",
  reward: "Ambulanssi"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "beepboopbeep",
  reward_type: "buff",
  reward: "Sword of a Thousand Truths"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "thisisabuffcodepleaseredeemme",
  reward_type: "buff",
  reward: "Mark of the Wild"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "vYYRmTHVkpsuLLrk",
  reward_type: "buff",
  reward: "Blessing of Kings"
})

# Experience buffs

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "iOgkbaQKdypruxC9",
  reward_type: "exp",
  reward: "50000"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "edes joku koodi",
  reward_type: "exp",
  reward: "50000"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "firstblood",
  reward_type: "exp",
  reward: "20000"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "tässäontiteenipelikoodi",
  reward_type: "exp",
  reward: "20000"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "oulupilaaainakaiken",
  reward_type: "exp",
  reward: "50000"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "bhyhcvynnnvanxnvxra",
  reward_type: "exp",
  reward: "50000"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "IDDQD",
  reward_type: "exp",
  reward: "100000"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "catsarejustalienswithextrasteps",
  reward_type: "exp",
  reward: "200000"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "xxx",
  reward_type: "exp",
  reward: "200000"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "The Secret Cow Level",
  reward_type: "exp",
  reward: "50000"
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Challenge{
  solution: "iF63oghHuGD9ZaEB",
  reward_type: "exp",
  reward: "20000"
})

# Zones

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Zone{
  name: "Tietotalo",
  background_image_url: "#{System.get_env("SERVER_URL")}/images/zones/tietotalo.jpg",
  min_level: 1,
  max_level: 10,
  required_kills: 128
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Zone{
  name: "Sähkötalo",
  background_image_url: "#{System.get_env("SERVER_URL")}/images/zones/sahkotalo.jpg",
  min_level: 8,
  max_level: 18,
  required_kills: 256
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Zone{
  name: "Rakennustalo",
  background_image_url: "#{System.get_env("SERVER_URL")}/images/zones/rakennustalo.jpeg",
  min_level: 15,
  max_level: 25,
  required_kills: 512
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Zone{
  name: "Päätalo",
  background_image_url: "#{System.get_env("SERVER_URL")}/images/zones/paatalo.jpg",
  min_level: 25,
  max_level: 35,
  required_kills: 1024
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Zone{
  name: "Festia",
  background_image_url: "#{System.get_env("SERVER_URL")}/images/zones/festia2.jpg",
  min_level: 30,
  max_level: 45,
  required_kills: 1024
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Zone{
  name: "Konetalo",
  background_image_url: "#{System.get_env("SERVER_URL")}/images/zones/konetalo2.jpg",
  min_level: 45,
  max_level: 55,
  required_kills: 1024
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Zone{
  name: "Kampusareena",
  background_image_url: "#{System.get_env("SERVER_URL")}/images/zones/kampusareena3.jpg",
  min_level: 55,
  max_level: 60,
  required_kills: 1024
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Zone{
  name: "Teekkarisauna",
  background_image_url: "#{System.get_env("SERVER_URL")}/images/zones/teekkarisauna2.jpg",
  min_level: 90,
  max_level: 100,
  required_kills: 666_666
})

zones =
  Titeenipeli.Repo.all(Titeenipeli.Model.Zone)
  # Don't create a boss for Teekkarisauna
  |> Enum.filter(fn zone -> zone.name != "Teekkarisauna" end)

Enum.each(zones, fn zone ->
  Titeenipeli.Repo.insert!(%Titeenipeli.Model.Zone{
    name: "#{zone.name} - Boss",
    required_kills: 1,
    background_image_url: zone.background_image_url,
    min_level: zone.min_level,
    max_level: zone.max_level,
    is_boss: true,
    parent_zone_id: zone.id
  })
end)

# Guild zones

zones = Titeenipeli.Repo.all(Titeenipeli.Model.Zone)

Titeenipeli.Repo.all(Titeenipeli.Model.Guild)
|> Enum.each(fn guild ->
  Enum.each(zones, fn zone ->
    Titeenipeli.Repo.insert!(%Titeenipeli.Model.GuildZone{
      guild_id: guild.id,
      zone_id: zone.id,
      unlocked: !zone.is_boss,
      unlocked_at: if(zone.is_boss, do: nil, else: DateTime.truncate(DateTime.utc_now(), :second))
    })
  end)
end)

# NPCs

zones =
  Titeenipeli.Repo.all(
    from z in Titeenipeli.Model.Zone,
      where: z.is_boss == false
  )

boss_zones =
  Titeenipeli.Repo.all(
    from z in Titeenipeli.Model.Zone,
      where: z.is_boss == true
  )

# Barrens / Tietotalo

tietotalo = Enum.find(zones, nil, fn zone -> zone.name == "Tietotalo" end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Mottled Boar",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/mottled-boar.png",
  base_hp: 4000,
  level: tietotalo.min_level,
  zone_id: tietotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Scorpid Worker",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/scorpid-worker.png",
  base_hp: 5500,
  level: tietotalo.min_level,
  zone_id: tietotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Savannah Prowler",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/savannah-prowler.png",
  base_hp: 4300,
  level: tietotalo.min_level + 1,
  zone_id: tietotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Bristleback Water Seeker",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/bristleback-water-seeker.png",
  base_hp: 4100,
  level: tietotalo.min_level + 2,
  zone_id: tietotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Kolkar Marauder",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/kolkar-marauder.png",
  base_hp: 4200,
  level: tietotalo.min_level + 3,
  zone_id: tietotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Sunscale Screecher",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/sunscale-screecher.png",
  base_hp: 4400,
  level: tietotalo.min_level + 5,
  zone_id: tietotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Thunderhead",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/thunderhead.png",
  base_hp: 4800,
  level: tietotalo.min_level + 7,
  zone_id: tietotalo.id
})

tietalo_boss_zone = Enum.find(boss_zones, nil, fn zone -> zone.parent_zone_id == tietotalo.id end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Mankrik",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/mankrik.png",
  base_hp: 200_000,
  level: tietalo_boss_zone.max_level,
  zone_id: tietalo_boss_zone.id,
  hp_regen: 2000
})

# Sähkötalo / Westfall

sahkotalo = Enum.find(zones, nil, fn zone -> zone.name == "Sähkötalo" end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Shore Crawler",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/shore_crawler.png",
  base_hp: 5500,
  level: sahkotalo.min_level,
  zone_id: sahkotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Shore Crawler",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/shore_crawler.png",
  base_hp: 5500,
  level: sahkotalo.min_level + 2,
  zone_id: sahkotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Shore Crawler",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/shore_crawler.png",
  base_hp: 5500,
  level: sahkotalo.min_level + 3,
  zone_id: sahkotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Ghoul",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/ghoul.png",
  base_hp: 5300,
  level: sahkotalo.min_level + 1,
  zone_id: sahkotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Ghoul",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/ghoul.png",
  base_hp: 5300,
  level: sahkotalo.min_level + 2,
  zone_id: sahkotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Harvest Reaper",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/harvest-reaper.png",
  base_hp: 5300,
  level: sahkotalo.min_level + 2,
  zone_id: sahkotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Harvest Reaper",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/harvest-reaper.png",
  base_hp: 5300,
  level: sahkotalo.min_level + 3,
  zone_id: sahkotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Harvest Reaper",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/harvest-reaper.png",
  base_hp: 5300,
  level: sahkotalo.min_level + 4,
  zone_id: sahkotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Brack",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/brack.png",
  base_hp: 5500,
  level: sahkotalo.min_level + 7,
  zone_id: sahkotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Defias Looter",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/defias-looter.png",
  base_hp: 5300,
  level: sahkotalo.min_level + 6,
  zone_id: sahkotalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Coyote Packleader",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/coyote-packleader.png",
  base_hp: 5300,
  level: sahkotalo.min_level + 2,
  zone_id: sahkotalo.id
})

sahkotalo_boss_zone =
  Enum.find(boss_zones, nil, fn zone -> zone.parent_zone_id == sahkotalo.id end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Kekken",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/kekken.webp",
  base_hp: 200_000,
  level: sahkotalo_boss_zone.max_level,
  zone_id: sahkotalo_boss_zone.id,
  hp_regen: 50000
})

# Rakennustalo / 6

rakennustalo = Enum.find(zones, nil, fn zone -> zone.name == "Rakennustalo" end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Hillsbrad Footman",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/hillsbrad-footman.png",
  base_hp: 6400,
  level: rakennustalo.min_level + 1,
  zone_id: rakennustalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Torn Fin Oracle",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/torn-fin-oracle.png",
  base_hp: 6800,
  level: rakennustalo.min_level + 1,
  zone_id: rakennustalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Grey Bear",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/grey-bear.png",
  base_hp: 7200,
  level: rakennustalo.min_level + 2,
  zone_id: rakennustalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Ferocious Yeti",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/ferocious-yeti.png",
  base_hp: 7500,
  level: rakennustalo.min_level + 3,
  zone_id: rakennustalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Syndicate Rogue",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/syndicate-rogue.png",
  base_hp: 7500,
  level: rakennustalo.min_level + 4,
  zone_id: rakennustalo.id
})

rakennustalo_boss_zone =
  Enum.find(boss_zones, nil, fn zone -> zone.parent_zone_id == rakennustalo.id end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Ruffe Oluennoutaja",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/ruffecs.png",
  base_hp: 200_000,
  level: rakennustalo_boss_zone.max_level,
  zone_id: rakennustalo_boss_zone.id,
  hp_regen: 80_000
})

# Päätalo / Wetlands

paatalo = Enum.find(zones, nil, fn zone -> zone.name == "Päätalo" end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Highland Scytheclaw",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/highland-scytheclaw.png",
  base_hp: 25300,
  level: paatalo.min_level,
  zone_id: paatalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Highland Scytheclaw",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/highland-scytheclaw.png",
  base_hp: 25300,
  level: paatalo.min_level + 1,
  zone_id: paatalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Highland Scytheclaw",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/highland-scytheclaw.png",
  base_hp: 25300,
  level: paatalo.min_level + 2,
  zone_id: paatalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Crimzon Ooze",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/crimzon-ooze.png",
  base_hp: 26500,
  level: paatalo.min_level + 2,
  zone_id: paatalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Crimzon Ooze",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/crimzon-ooze.png",
  base_hp: 26500,
  level: paatalo.min_level + 3,
  zone_id: paatalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Fen Creeper",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/fen-creeper.png",
  base_hp: 27000,
  level: paatalo.min_level + 4,
  zone_id: paatalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Fen Creeper",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/fen-creeper.png",
  base_hp: 27000,
  level: paatalo.min_level + 5,
  zone_id: paatalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Fen Creeper",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/fen-creeper.png",
  base_hp: 27000,
  level: paatalo.min_level + 6,
  zone_id: paatalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Crimson Whelp",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/crimson-whelp.png",
  base_hp: 25300,
  level: paatalo.min_level + 7,
  zone_id: paatalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Crimson Whelp",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/crimson-whelp.png",
  base_hp: 30300,
  level: paatalo.min_level + 8,
  zone_id: paatalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Hammerhead Shark",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/hammerhead-shark.png",
  base_hp: 32300,
  level: paatalo.min_level + 9,
  zone_id: paatalo.id
})

paatalo_boss_zone = Enum.find(boss_zones, nil, fn zone -> zone.parent_zone_id == paatalo.id end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Onyxia",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/onyxia.gif",
  base_hp: 200_000,
  level: paatalo_boss_zone.max_level,
  zone_id: paatalo_boss_zone.id,
  hp_regen: 250_000
})

# Festia / BWL / Nefarian

festia = Enum.find(zones, nil, fn zone -> zone.name == "Festia" end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Corrupted Red Whelp",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/corrupted-red-whelp.png",
  base_hp: 32300,
  level: festia.min_level,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Corrupted Green Whelp",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/corrupted-green-whelp.png",
  base_hp: 32300,
  level: festia.min_level + 1,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Corrupted Blue Whelp",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/corrupted-blue-whelp.png",
  base_hp: 32300,
  level: festia.min_level + 2,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Corrupted Bronze Whelp",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/corrupted-bronze-whelp.png",
  base_hp: 32300,
  level: festia.min_level + 3,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Blackwing Mage",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/corrupted-bronze-whelp.png",
  base_hp: 32300,
  level: festia.min_level + 5,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Blackwing Legionnaire",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/corrupted-bronze-whelp.png",
  base_hp: 23300,
  level: festia.min_level + 6,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Blackwing Legionnaire",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/corrupted-bronze-whelp.png",
  base_hp: 32300,
  level: festia.min_level + 6,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Blackwing Taskmaster",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/corrupted-bronze-whelp.png",
  base_hp: 32300,
  level: festia.min_level + 7,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Black Drakonid",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/black-drakonid.png",
  base_hp: 32300,
  level: festia.min_level + 8,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Red Drakonid",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/red-drakonid.png",
  base_hp: 32300,
  level: festia.min_level + 9,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Bone Construct",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/bone-construct.png",
  base_hp: 32300,
  level: festia.min_level + 10,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Enraged Felguard",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/felguard.png",
  base_hp: 32300,
  level: festia.min_level + 11,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Death Talon Hatcher",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/death-talon-hatcher.png",
  base_hp: 32300,
  level: festia.min_level + 12,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Death Talon Wyrmkin",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/death-talon-hatcher.png",
  base_hp: 32300,
  level: festia.min_level + 13,
  zone_id: festia.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Death Talon Flamescale",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/death-talon-flamescale.png",
  base_hp: 32300,
  level: festia.min_level + 14,
  zone_id: festia.id
})

festia_boss_zone = Enum.find(boss_zones, nil, fn zone -> zone.parent_zone_id == festia.id end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Nefarian",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/nefarian.gif",
  base_hp: 20_000_000
  level: festia_boss_zone.max_level,
  zone_id: festia_boss_zone.id,
  hp_regen: 10_000_000
})

# Konetalo / Molten Core

konetalo = Enum.find(zones, nil, fn zone -> zone.name == "Konetalo" end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Firesworn",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/firesworn.png",
  base_hp: 88500,
  level: konetalo.min_level + 1,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Flamewaker Healer",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/flamewaker-healer.png",
  base_hp: 88100,
  level: konetalo.min_level + 3,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Flamewaker Elite",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/flamewaker-healer.png",
  base_hp: 88200,
  level: konetalo.min_level + 5,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Lava Spawn",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/lava-spawn.png",
  base_hp: 88300,
  level: konetalo.min_level + 2,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Son of Flame",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/lava-spawn.png",
  base_hp: 88500,
  level: konetalo.min_level + 3,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Firelord",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/lava-spawn.png",
  base_hp: 88700,
  level: konetalo.min_level + 4,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Doomguard",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/doomguard.png",
  base_hp: 90000,
  level: konetalo.min_level + 7,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Core Hound",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/corehound.png",
  base_hp: 88800,
  level: konetalo.min_level + 6,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Core Rager",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/corehound.png",
  base_hp: 88800,
  level: konetalo.min_level + 5,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Ancient Core Hound",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/corehound.png",
  base_hp: 88800,
  level: konetalo.min_level + 8,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Flame Imp",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/flamewaker-imp.png",
  base_hp: 88200,
  level: konetalo.min_level,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Molten Giant",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/molten-giant.png",
  base_hp: 90000,
  level: konetalo.max_level,
  zone_id: konetalo.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Molten Destroyer",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/molten-giant.png",
  base_hp: 90000,
  level: konetalo.max_level - 1,
  zone_id: konetalo.id
})

konetalo_boss_zone = Enum.find(boss_zones, nil, fn zone -> zone.parent_zone_id == konetalo.id end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Ragnaros",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/ragnaros.gif",
  base_hp: 50_000_000,
  level: konetalo_boss_zone.max_level,
  zone_id: konetalo_boss_zone.id,
  hp_regen: 500_000_000
})

# Kampusareena / Hellfire Peninsula

kampusareena = Enum.find(zones, nil, fn zone -> zone.name == "Kampusareena" end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Flamewaker Imp",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/flamewaker-imp.png",
  base_hp: 150500,
  level: kampusareena.min_level,
  zone_id: kampusareena.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Netherhound",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/netherhound.png",
  base_hp: 150700,
  level: kampusareena.min_level + 4,
  zone_id: kampusareena.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Bonechewer Evoker",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/bonechewer-evoker.png",
  base_hp: 150000,
  level: kampusareena.min_level + 3,
  zone_id: kampusareena.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Bonechewer Scavenger",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/bonechewer-scavenger.png",
  base_hp: 150200,
  level: kampusareena.min_level + 2,
  zone_id: kampusareena.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Fel Handler",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/fel-handler.png",
  base_hp: 150500,
  level: kampusareena.min_level + 3,
  zone_id: kampusareena.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Infernal Warbringer",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/infernal-warbringer.png",
  base_hp: 150900,
  level: kampusareena.min_level + 4,
  zone_id: kampusareena.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Starving Helboar",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/starving-helboar.png",
  base_hp: 150300,
  level: kampusareena.min_level + 1,
  zone_id: kampusareena.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Dreadcaller",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/dreadcaller.png",
  base_hp: 150800,
  level: kampusareena.min_level + 3,
  zone_id: kampusareena.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Doomwhisperer",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/doomwhisperer.png",
  base_hp: 150500,
  level: kampusareena.min_level + 4,
  zone_id: kampusareena.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Wrathguard",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/wrathguard.png",
  base_hp: 150600,
  level: kampusareena.min_level + 4,
  zone_id: kampusareena.id
})

kampusareena_boss_zone =
  Enum.find(boss_zones, nil, fn zone -> zone.parent_zone_id == kampusareena.id end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Tuniliitti",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/tuniliitti.webp",
  base_hp: 100_000_000,
  level: kampusareena_boss_zone.max_level,
  zone_id: kampusareena_boss_zone.id,
  hp_regen: 1_000_000_000
})

# Teekkarisauna / The Secret Cow Level

teekkarisauna = Enum.find(zones, nil, fn zone -> zone.name == "Teekkarisauna" end)

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Hell Bovine",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/hell_bovine.gif",
  base_hp: 66666,
  level: teekkarisauna.min_level,
  zone_id: teekkarisauna.id
})
Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Hell Bovine",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/hell_bovine.gif",
  base_hp: 66666,
  level: teekkarisauna.min_level + 1,
  zone_id: teekkarisauna.id
})
Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Hell Bovine",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/hell_bovine.gif",
  base_hp: 66666,
  level: teekkarisauna.min_level + 2,
  zone_id: teekkarisauna.id
})
Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Hell Bovine",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/hell_bovine.gif",
  base_hp: 66666,
  level: teekkarisauna.min_level + 3,
  zone_id: teekkarisauna.id
})
Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Hell Bovine",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/hell_bovine.gif",
  base_hp: 66666,
  level: teekkarisauna.min_level + 4,
  zone_id: teekkarisauna.id
})
Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Hell Bovine",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/hell_bovine.gif",
  base_hp: 66666,
  level: teekkarisauna.min_level + 5,
  zone_id: teekkarisauna.id
})
Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Hell Bovine",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/hell_bovine.gif",
  base_hp: 66666,
  level: teekkarisauna.min_level + 4,
  zone_id: teekkarisauna.id
})
Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Hell Bovine",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/hell_bovine.gif",
  base_hp: 66666,
  level: teekkarisauna.min_level + 3,
  zone_id: teekkarisauna.id
})
Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "Hell Bovine",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/hell_bovine.gif",
  base_hp: 66666,
  level: teekkarisauna.min_level + 2,
  zone_id: teekkarisauna.id
})

Titeenipeli.Repo.insert!(%Titeenipeli.Model.Npc{
  name: "The Cow King",
  image_url: "#{System.get_env("SERVER_URL")}/images/npcs/cowking.gif",
  base_hp: 666666,
  level: 100,
  zone_id: teekkarisauna.id
})
