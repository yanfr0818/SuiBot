# SuiBot

A high-performance Telegram bot that monitors Bilibili live streams and forwards events to Telegram channels. Based on [LAPLACE Jupiter](https://github.com/laplace-live/jupiter).

## Features

- 🔌 Connects to multiple LAPLACE Event Bridges simultaneously
- 📡 Aggregates events from all connected bridges
- 🎯 Room-based event filtering and routing  
- 💬 Different channels for different event types (gifts vs other events)
- 🔄 Automatic reconnection support for each bridge
- 📋 YAML-based configuration
- 🔀 Fault tolerance - continues running even if some bridges fail
- 🚀 Optimized for Fly.io deployment with persistent storage

## Prerequisites

Before you begin, you'll need:

1. **Bun** runtime installed: https://bun.sh
2. **Telegram Bot Token** from [@BotFather](https://t.me/botfather)
3. **Telegram API ID and Hash** from [my.telegram.org](https://my.telegram.org)
4. **LAPLACE Event Bridge** WebSocket server (self-hosted)
5. **Telegram Channel IDs** where events will be forwarded
6. **Bilibili Room IDs** to monitor

## Installation

```bash
# Clone or download this repository
cd BiliBot

# Install dependencies
bun install
```

## Configuration

### 1. Create Environment Variables

Copy the example and fill in your Telegram credentials:

```bash
cp .env.example .env
```

Edit `.env`:

```env
TELEGRAM_API_ID=your_telegram_api_id
TELEGRAM_API_HASH=your_telegram_api_hash
TELEGRAM_BOT_TOKEN=your_bot_token
```

### 2. Create Configuration File

Copy the example and configure your rooms:

```bash
cp config.example.yaml config.yaml
```

Edit `config.yaml` with your Event Bridge URLs and room settings. See [Configuration Guide](#configuration-guide) below.

## Configuration Guide

### Event Bridge Settings

```yaml
bridges:
  - name: primary                    # Unique identifier for this bridge
    url: wss://your-bridge.com       # WebSocket URL of your Event Bridge
    token: optional_auth_token       # Optional authentication token
```

### Room Settings

```yaml
rooms:
  - room_id: 25034104                # Bilibili room ID
    slug: room_name                  # Human-readable name
    uid: 2132180406                  # Streamer's UID (optional)
    telegram_announce_ch: -1001234567890  # Channel for messages
    telegram_watchers_ch: -1001234567890  # Channel for gifts/donations
    minimum_gift_price: 100000       # Min gift value (100 CNY)
    minimum_guard_price: 200000      # Min guard value (200 CNY)
    notify_room_enter: false         # Notify on user enter
    vip_users: []                    # VIP user IDs to monitor
```

## Local Development

Run the bot in development mode with hot reload:

```bash
bun run dev
```

Or run normally:

```bash
bun run start
```

## Deploying to Fly.io

### Prerequisites

1. Install Fly.io CLI: https://fly.io/docs/hands-on/install-flyctl/
2. Sign up for Fly.io account: https://fly.io/app/sign-up

### Deployment Steps

#### 1. Login to Fly.io

```bash
flyctl auth login
```

#### 2. Create and Configure App

```bash
# Launch the app (this will create it)
flyctl launch

# When prompted:
# - Choose a unique app name (or accept generated)
# - Choose your region (nrt = Tokyo, sjc = San Jose, etc.)
# - Do NOT deploy yet - say "No" when asked
```

#### 3. Create Persistent Volume

The bot needs storage for session data:

```bash
flyctl volumes create bilibot_data --region nrt --size 1
```

Replace `nrt` with your chosen region.

#### 4. Set Environment Variables

```bash
flyctl secrets set TELEGRAM_API_ID=your_api_id
flyctl secrets set TELEGRAM_API_HASH=your_api_hash
flyctl secrets set TELEGRAM_BOT_TOKEN=your_bot_token
```

#### 5. Upload Configuration File

Fly.io doesn't have a direct way to upload files, so you have two options:

**Option A: Include in Docker build** (Recommended for testing)
- Temporarily create `config.yaml` locally
- Deploy (it will be included in the Docker image)
- **Warning:** Config is baked into the image

**Option B: Use Fly.io Secrets** (Better for production)
- Convert your YAML to environment variables
- Use `flyctl secrets set` for each value

For now, let's use Option A:

```bash
cp config.example.yaml config.yaml
# Edit config.yaml with your settings
```

#### 6. Deploy

```bash
flyctl deploy
```

#### 7. Monitor Logs

```bash
flyctl logs
```

You should see:
- "Logged in as [bot username]"
- "Connected to event bridge: primary"
- "Room monitoring config: ..."

### Managing Your Deployment

```bash
# View app status
flyctl status

# Scale resources (if needed)
flyctl scale memory 512  # Increase to 512MB

# SSH into the container
flyctl ssh console

# Restart the app
flyctl apps restart

# Update secrets
flyctl secrets set TELEGRAM_BOT_TOKEN=new_token

# Destroy the app (careful!)
flyctl apps destroy bilibot
```

## Setting Up Event Bridge

You need a LAPLACE Event Bridge server running. Quick setup:

```bash
# Download the Event Bridge binary
wget https://github.com/laplace-live/event-bridge/releases/latest/download/leb-server-linux-amd64

# Make it executable
chmod +x leb-server-linux-amd64

# Run it (with authentication)
./leb-server-linux-amd64 --host 0.0.0.0 --auth "your-secret-token"
```

For more details, see [LAPLACE Event Bridge docs](https://subspace.institute/docs/laplace-chat/event-bridge).

## Getting Telegram Channel IDs

1. Add your bot to a Telegram channel as administrator
2. Send a message to the channel
3. Visit: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
4. Look for `"chat":{"id":-1001234567890}` in the JSON response

## Event Types

The bot forwards these Bilibili events:

- **Messages** - Chat messages from streamers/VIP users
- **Gifts** - Gift donations (above threshold)
- **Superchats** - Superchat/SC donations
- **Guards** - Guard/membership purchases
- **Lottery** - Lottery start and results
- **Stream Status** - Stream start/stop
- **Moderation** - Warnings, bans, mutes
- **Room Updates** - Title changes, mod assignments

## Troubleshooting

### Bot won't start

- Check environment variables are set correctly
- Verify `config.yaml` syntax is valid
- Ensure Event Bridge is running and accessible

### No events appearing in Telegram

- Verify Telegram channel IDs are correct (include the `-` sign)
- Check bot has admin rights in channels
- Verify Event Bridge is receiving Bilibili events
- Check gift/guard price thresholds aren't too high

### Connection errors

- Ensure Event Bridge WebSocket URL is correct (`wss://` or `ws://`)
- Check authentication token matches (if using one)
- Verify network connectivity to Event Bridge

## Development

```bash
# Format code
bun run format

# Lint code
bun run lint
```

## License

MIT

## Credits

Based on [LAPLACE Jupiter](https://github.com/laplace-live/jupiter) by the LAPLACE team.
