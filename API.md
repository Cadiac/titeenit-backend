# Websocket API

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**NOTE**: NOT UP TO DATE

This was written back in 2019/2020, and not updated later, even though the websocket
API changed. Sadly the websocket API that exists now is now partially undocumented.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## JavaScript API usage:

```javascript
import { Channel, Socket } from "phoenix";

const gamesocket = new Socket("ws://localhost:4000/socket", {
  params: { token: "token" }
});

gamesocket.connect();

const gamechannel = gamesocket.channel("game:tite", {});

gamechannel
  .join(5000)
  .receive("ok", resp => {****
      console.log("Joined successfully", resp);
  });

gamechannel.push("game:get_status", {}).receive("ok", (reply) => {
  // Do something
});

gamechannel.on("game:player_connected", (payload) => {
  // do something
});
```

## Game channel

Join channel with name `game:tite`, where `tite` is one of the guild ids:

- `tite`
- `otit`
- `digit`
- `tik`
- `cluster`

### Inbound messages (commands)

Client can push these messages to the server

```javascript
gamechannel.push("game:get_status", {}).receive("ok", (reply) => {
  // Do something
});
```

#### Cast spell `game:begin_cast`

Command: `game:begin_cast`
```json
{
  "spell_id": 123
}
```

Note: The cooldown timestmap (time when spell is ready again) is returned in UTC time.

Attack reply:
```json
{
  "npc": {
    "name": "Mottled Boar",
    "max_hp": 200,
    "hp": 200,
    "level": 1,
    "image_url": "http://example.com"
  },
  "type": "attack",
  "damage": {
    "value": 39,
    "min_damage": 10,
    "max_damage": 50,
    "is_crit": false
  },
  "cooldown": "2020-02-25T19:13:42.943446Z"
}
```

Global buff reply:
```json
{
  "npc": {
    "name": "Mottled Boar",
    "max_hp": 200,
    "hp": 200,
    "level": 1,
    "image_url": "http://example.com"
  },
  "type": "global_buff",
  "damage": null,
  "cooldown": "2020-02-25T19:13:42.943446Z"
}
```

Personal buff reply:
```json
{
  "npc": {
    "name": "Mottled Boar",
    "max_hp": 200,
    "hp": 200,
    "level": 1,
    "image_url": "http://example.com"
  },
  "type": "buff",
  "damage": null,
  "cooldown": "2020-02-25T19:13:42.943446Z"
}
```

#### Join game (old `game:get_status`)

Command: `game:get_status`
```json
{}
```

Reply:
```json
{
  "id": "tite",
  "guild": "Tampereen TietoTeekkarikilta",
  "guild_id": "1",
  "zone_id": "1",
  "players": ["Cadiac", "Shancial"],
  "max_players": 1000,
  "cooldowns": {
    "1": "2020-02-29T21:40:44.921080Z",
    "2": "2020-02-29T21:40:48.780592Z",
    "3": "2020-02-29T21:40:52.749782Z",
    "4": "2020-02-29T21:40:56.711034Z",
    "5": "1970-01-01T00:00:00Z",
    "6": "2020-02-29T21:41:19.144154Z",
    "7": "1970-01-01T00:00:00Z",
  },
  "buffs": [
    {
      "id": "026dbbd4-fe29-4e78-8a9e-21f274293923",
      "cooldown_multiplier": 0.7,
      "crit_multiplier": 1,
      "damage_multiplier": 1,
      "duration_ms": 30000,
      "expires_at": "2020-02-29T19:01:49.439560Z",
      "icon_url": "https://sivu.dev/images/icons/spell_nature_bloodlust.jpg",
      "name": "Bloodlust"
    }
  ],
  "spells": [
    {
      "cast_time": 1500,
      "cooldown": 0,
      "icon_url": "http://localhost:4000/images/icons/spell_fire_flamebolt.jpg",
      "id": 1,
      "name": "Fireball",
      "required_level": 1,
      "type": "attack",
      "description": "Hurls a fiery ball that causes 123 to 151 Fire damage."
    },
    {
      "cast_time": 0,
      "cooldown": 8000,
      "icon_url": "http://localhost:4000/images/icons/spell_fire_fireball.jpg",
      "id": 2,
      "name": "Fireblast",
      "required_level": 6,
      "type": "attack",
      "description": "Blasts the enemy for 12 to 40 Fire damage."
    },¨
    {
      "cast_time": 6000,
      "cooldown": 12000,
      "icon_url": "http://localhost:4000/images/icons/spell_fire_fireball02.jpg",
      "id": 4,
      "name": "Pyroblast",
      "required_level": 14,
      "type": "attack",
      "description": "Hurls an immense fiery boulder that causes 211 to 231 Fire damage"
    },
    {
      "cast_time": 0,
      "cooldown": 300000,
      "icon_url": "http://localhost:4000/images/icons/spell_holy_magicalsentry.jpg",
      "id": 5,
      "name": "Arcane Intellect",
      "required_level": 10,
      "type": "global_buff",
      "description": "Infuses the target's raid with brilliance, increasing their damage and critical strike chance for 5 minutes."
    },
    {
      "cast_time": 0,
      "cooldown": 180000,
      "icon_url": "http://localhost:4000/images/icons/spell_holy_magicalsentry.jpg",
      "id": 7,
      "name": "Arcane Power",
      "required_level": 30,
      "type": "buff",
      "description": "When activated, your spells deal 30% more damage. This effect lasts 30 sec."
    }
  ],
  "npc": {
    "name": "Mottled Boar",
    "max_hp": 200,
    "hp": 200,
    "level": 1,
    "image_url": "http://example.com"
  },
  "zone": {
    "cleared": false,
    "cleared_at": "2020-02-29T19:01:49.439560Z",
    "unlocked": true,
    "unlocked_at": "2020-02-29T19:01:49.439560Z",
    "max_level": 20,
    "min_level": 10,
    "name": "Tietotalo",
    "required_kills": 100,
    "current_kills": 1,
    "background_image_url": "https://sivu.dev/images/zones/tietotalo.jpg"
  }
}
```

### Outbound messages

Clients can listen for these messages as they are broadcasted to all clients on the channel

```javascript
gamechannel.on("game:player_connected", (payload) => {
  // do something
});
```

#### Player connected

Message: `game:player_connected`

```json
{
  "id": 12345678,
  "username": "Cadiac"
}
```

#### Player disconencted

Message: `game:player_disconnected`
```json
{
  "id": 12345678,
  "username": "Cadiac"
}
```

#### NPC updated

Message: `game:npc_updated`
```json
{
  "npc": {
    "name": "Mottled Boar",
    "max_hp": 200,
    "hp": 200,
    "level": 1,
    "image_url": "http://example.com"
  },
  "zone": {
    "cleared": false,
    "cleared_at": "2020-02-29T19:01:49.439560Z",
    "unlocked": true,
    "unlocked_at": "2020-02-29T19:01:49.439560Z",
    "max_level": 20,
    "min_level": 10,
    "name": "Tietotalo",
    "required_kills": 100,
    "current_kills": 1,
    "background_image_url": "https://sivu.dev/images/zones/tietotalo.jpg"
  }
}
```

#### NPC defeated

Message: `game:npc_updated`
```json
{
  "npc": {
    "name": "Mottled Boar",
    "max_hp": 200,
    "hp": 200,
    "level": 1,
    "image_url": "http://example.com"
  }
}
```

#### Global buff gained

Message: `game:buff_gained`
```json
{
  "id": "026dbbd4-fe29-4e78-8a9e-21f274293923",
  "cooldown_multiplier": 0.7,
  "crit_multiplier": 1,
  "damage_multiplier": 1,
  "duration_ms": 30000,
  "expires_at": "2020-02-29T19:01:49.439560Z",
  "icon_url": "https://sivu.dev/images/icons/spell_nature_bloodlust.jpg",
  "name": "Bloodlust"
}
```

#### Global buff faded

Message: `game:buff_faded`
```json
{
  "id": "026dbbd4-fe29-4e78-8a9e-21f274293923",
  "cooldown_multiplier": 0.7,
  "crit_multiplier": 1,
  "damage_multiplier": 1,
  "duration_ms": 30000,
  "expires_at": "2020-02-29T19:01:49.439560Z",
  "icon_url": "https://sivu.dev/images/icons/spell_nature_bloodlust.jpg",
  "name": "Bloodlust"
}
```

#### Server message

types: `"chat"`, `"join"`, `"quit"`, `"server"`

Message: `game:server_message`
```json
{
  "text": "Mottled Boar dies, you gain 576 experience.",
  "type": "server"
}
```

### Error messages

Payload:
```json
{
  "reason": "Error text here"
}
```

## User channel

Authenticated user can join its own personal channel with name `user:#{user_id}`.

### Outbound messages

Clients can listen for these messages as they are broadcasted to them on the channel

```javascript
gamechannel.on("user:exp_updated", (payload) => {
  // do something
});
```

#### Experience gained `user:exp_updated`

Message: `user:exp_updated`

```json
{
  "experience": 1250,
  "experience_required": 5000,
  "experience_change": 75,
  "total_experience": 12500,
  "level":5,
  "is_levelup": false,
  "message": "Mottled Boar dies, you gain 75 experience."
}
```

#### User buff gained

Message: `user:buff_gained`
```json
{
  "id": "026dbbd4-fe29-4e78-8a9e-21f274293923",
  "cooldown_multiplier": 0.7,
  "crit_multiplier": 1,
  "damage_multiplier": 1,
  "duration_ms": 30000,
  "expires_at": "2020-02-29T19:01:49.439560Z",
  "icon_url": "https://sivu.dev/images/icons/spell_nature_bloodlust.jpg",
  "name": "Bloodlust"
}
```

#### User buff faded

Message: `user:buff_faded`
```json
{
  "id": "026dbbd4-fe29-4e78-8a9e-21f274293923",
  "cooldown_multiplier": 0.7,
  "crit_multiplier": 1,
  "damage_multiplier": 1,
  "duration_ms": 30000,
  "expires_at": "2020-02-29T19:01:49.439560Z",
  "icon_url": "https://sivu.dev/images/icons/spell_nature_bloodlust.jpg",
  "name": "Bloodlust"
}
```

#### User spell unlocked

Message: `user:spell_unlocked`
```json
{
  "cast_time": 1500,
  "cooldown": 0,
  "icon_url": "http://localhost:4000/images/icons/spell_fire_flamebolt.jpg",
  "id": 1,
  "name": "Fireball",
  "required_level": 1,
  "type": "attack",
  "description": "Hurls a fiery ball that causes 123 to 151 Fire damage."
}
```

## Global chat channel

Authenticated user can join global chat channel `chat:global`.

### Inbound messages

Client can push these messages to the server

```javascript
chatchannel.push("chat:send_global_message", { text: "LFG RFC" }).receive("ok", (reply) => {
  // Do something
});
```

#### Send chat message `chat:send_global_message`

Command: `chat:send_global_message`
```json
{
  "text": "LFG RFC"
}
```
No reply.

### Outbound messages

Clients can listen for these messages as they are broadcasted to them on the channel

```javascript
chatchannel.on("chat:chat_message", (payload) => {
  // do something
});
```

#### Receive global chat message `chat:chat_message`

Message: `chat:chat_message`

```json
{
  "from": {
    "id": 123456789,
    "username": "Cadiac",
    "guild_id": 1,
    "level": 15
  },
  "text": "LFG RFC",
  "timestamp": "2020-02-25T19:13:42.943446Z",
  "type": "chat"
}
```
