# Clawdbot Railway Template

One-click deployment template for [Clawdbot](https://github.com/clawdbot/clawdbot) on Railway. Clawdbot is an AI assistant platform supporting WhatsApp, Telegram, Discord, and other messaging channels.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/template/clawdbot)

## Quick Start

### 1. Deploy the Template

1. Click the **Deploy on Railway** button above
2. Fill in your AI provider API key (at least one required):
   - `ANTHROPIC_API_KEY` - for Claude models
   - `OPENAI_API_KEY` - for OpenAI models
   - `OPENROUTER_API_KEY` - for OpenRouter models
3. The `CLAWDBOT_GATEWAY_PASSWORD` is auto-generated for you
4. Click **Deploy**

### 2. Add a Volume (Required)

Railway containers lose their filesystem on each deploy. You must attach a volume:

1. After deployment, go to your service in the Railway dashboard
2. Right-click the service → **Attach Volume**
3. Set **Mount Path** to `/data`
4. Click **Add** then **Redeploy** the service

### 3. Configure Channels via SSH

After your service is running, use Railway's SSH to configure messaging channels:

```bash
# Install Railway CLI (one-time setup)
npm install -g @railway/cli

# Login to Railway
railway login

# Link to your project (follow the prompts)
railway link

# SSH into your running container
railway ssh
```

Once connected via SSH, run the onboarding wizard:

```bash
# Inside the Railway container
clawdbot onboard
```

The wizard will guide you through setting up:
- **Telegram** - Get a bot token from [@BotFather](https://t.me/BotFather)
- **Discord** - Create a bot at [Discord Developer Portal](https://discord.com/developers/applications)
- **WhatsApp** - Scan QR code for WhatsApp Web
- **Other channels** - Slack, Signal, Teams, etc.

### 4. Verify It's Working

1. Enable public networking: **Settings** → **Networking** → **Generate Domain**
2. Visit your gateway URL to see the dashboard
3. Send a message to your bot on Telegram/Discord/etc.

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CLAWDBOT_GATEWAY_PASSWORD` | Auto | *(generated)* | Gateway authentication (auto-generated) |
| `ANTHROPIC_API_KEY` | No* | - | API key for Claude models |
| `OPENAI_API_KEY` | No* | - | API key for OpenAI models |
| `OPENROUTER_API_KEY` | No* | - | API key for OpenRouter models |
| `CLAWDBOT_STATE_DIR` | Auto | `/data/.clawdbot` | Config storage (set by Dockerfile) |

> *At least one AI provider API key is required

## Volume Storage

The volume at `/data` persists across deploys:

```
/data/
├── .clawdbot/          # Clawdbot configuration
│   ├── clawdbot.json   # Main config file
│   ├── credentials/    # Channel credentials (Telegram tokens, etc.)
│   └── agents/         # Agent state and auth profiles
└── clawd/              # Workspace
    ├── skills/         # Custom skills
    └── memory/         # Conversation memory
```

## Common Tasks

### Adding a New Channel

```bash
railway ssh

# Then inside the container:
clawdbot onboard  # Run wizard again, or use specific commands:

# Telegram
clawdbot channels add telegram

# Discord
clawdbot channels add discord

# WhatsApp
clawdbot channels add whatsapp
```

### Checking Channel Status

```bash
railway ssh

# Inside container:
clawdbot channels status
clawdbot channels logs telegram
```

### Creating/Managing Agents

```bash
railway ssh

# Inside container:
clawdbot agents list
clawdbot agents create my-agent
clawdbot agents config my-agent --provider anthropic --model claude-sonnet-4-20250514
```

### Viewing Logs

From Railway dashboard:
- Click **Deployments** → select deployment → **View Logs**

Or via CLI:
```bash
railway logs
```

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Railway Container                     │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌────────────────────────────┐  │
│  │  Clawdbot CLI   │───▶│     Gateway (port 18789)   │  │
│  └─────────────────┘    └────────────────────────────┘  │
│           │                          │                   │
│           ▼                          ▼                   │
│  ┌─────────────────────────────────────────────────────┐│
│  │              Volume mounted at /data                ││
│  │  ┌──────────────────┐  ┌────────────────────────┐  ││
│  │  │  /data/.clawdbot │  │     /data/clawd        │  ││
│  │  │  (config/state)  │  │     (workspace)        │  ││
│  │  └──────────────────┘  └────────────────────────┘  ││
│  └─────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────┘
```

## Troubleshooting

### Gateway won't start

**Check logs for errors:**
- Railway dashboard → **Deployments** → **View Logs**

**Common causes:**
- Missing volume mount at `/data`
- No AI provider API key configured

### State not persisting between deploys

1. Verify volume exists: **Settings** → **Volumes**
2. Confirm mount path is exactly `/data`
3. Check volume has available space

### SSH connection fails

1. Ensure the service is running (not crashed)
2. Verify you're logged in: `railway login`
3. Link your project: `railway link`

### Channel not responding

```bash
railway ssh

# Check status
clawdbot channels status

# View channel logs
clawdbot channels logs telegram
```

### Health check failing

1. Check deployment logs for startup errors
2. Verify port 18789 is exposed
3. Increase `healthcheckTimeout` in `railway.toml` if needed

## Updating Clawdbot

To update to the latest version:

1. Railway dashboard → **Deployments** → **Redeploy**

The Dockerfile uses `clawdbot@latest`, so each rebuild fetches the newest version.

## Resources

- [Clawdbot Documentation](https://docs.clawd.bot)
- [Clawdbot GitHub](https://github.com/clawdbot/clawdbot)
- [Railway Documentation](https://docs.railway.app)
- [Railway CLI Guide](https://docs.railway.com/guides/cli)

## License

Apache License 2.0 - see [LICENSE](LICENSE) file for details.
