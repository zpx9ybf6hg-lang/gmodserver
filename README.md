# Garry's Mod DarkRP Server for Railway

A containerized Garry's Mod DarkRP server that can be deployed to Railway via GitHub.

## 🚀 Features

- **DarkRP Gamemode** - Automatically installs the latest DarkRP
- **Easy Deployment** - Deploy to Railway with one click
- **Configurable** - Customize server settings via environment variables
- **Workshop Support** - Add Steam Workshop collections
- **Auto-Updates** - Server files update on each restart

## 📋 Prerequisites

- A GitHub account
- A Railway account ([railway.app](https://railway.app))
- Garry's Mod (to connect to your server)
- (Optional) Steam API key for Workshop content

## 🛠️ Setup Instructions

### 1. Push to GitHub

```bash
cd "/Users/cldstprd/gmod server"
git init
git add .
git commit -m "Initial commit - GMod DarkRP server"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git push -u origin main
```

### 2. Deploy to Railway

1. Go to [railway.app](https://railway.app) and sign in
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose your repository
5. Railway will automatically detect the Dockerfile and start building

### 3. Configure Environment Variables

In your Railway project dashboard:

1. Go to **Variables** tab
2. Add the following variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `GMOD_HOSTNAME` | Server name shown in browser | `My Awesome DarkRP Server` |
| `GMOD_MAP` | Starting map | `rp_downtown_v4c_v2` |
| `GMOD_MAXPLAYERS` | Maximum players | `16` |
| `GMOD_GAMEMODE` | Gamemode | `darkrp` |
| `GMOD_WORKSHOP_API_KEY` | Steam API key (optional) | `your_api_key` |
| `GMOD_WORKSHOP_COLLECTION` | Workshop collection ID (optional) | `123456789` |

### 4. Get Your Server Address

1. In Railway, go to **Settings** tab
2. Scroll to **Networking**
3. Click **Generate Domain** to get a public URL
4. Note: Railway will assign a TCP port, but GMod needs UDP. You may need to use the Railway proxy address.

### 5. Connect to Your Server

In Garry's Mod:
1. Open console with `` ` `` (tilde key)
2. Type: `connect YOUR_RAILWAY_DOMAIN:PORT`
3. Or find it in the server browser

## 🎮 Popular DarkRP Maps

The server defaults to `rp_downtown_v4c_v2`. Other popular maps:

- `rp_rockford_v2b` - Modern city with detailed interiors
- `rp_evocity_v4b1` - Classic DarkRP map
- `rp_florida_v2` - Florida-themed city
- `rp_bangclaw_v5` - Large urban environment

Change the map by setting `GMOD_MAP` environment variable in Railway.

## 🔧 Configuration

### Server Settings

Edit `server.cfg` to customize:
- RCON password (⚠️ **Change this!**)
- Player limits
- Sandbox restrictions
- Voice chat settings
- Server rules

### DarkRP Settings

DarkRP configuration is located in:
```
garrysmod/gamemodes/darkrp/gamemode/config/
```

You can customize jobs, weapons, and rules by modifying these files after deployment.

## 📦 Adding Workshop Content

### Get a Steam API Key

1. Go to [https://steamcommunity.com/dev/apikey](https://steamcommunity.com/dev/apikey)
2. Enter a domain name (can be anything, e.g., `localhost`)
3. Copy your API key

### Create a Workshop Collection

1. Go to Steam Workshop for Garry's Mod
2. Click **"Workshop"** → **"Browse"** → **"Collections"**
3. Create a new collection
4. Add addons you want (DarkRP addons, maps, etc.)
5. Make the collection **Public**
6. Copy the collection ID from the URL

### Configure in Railway

Add these environment variables:
- `GMOD_WORKSHOP_API_KEY` = Your Steam API key
- `GMOD_WORKSHOP_COLLECTION` = Your collection ID

The server will automatically download and mount all workshop content on startup.

## 🐛 Troubleshooting

### Server won't start

- Check Railway logs for errors
- Ensure all environment variables are set correctly
- Verify the Dockerfile built successfully

### Can't connect to server

- **UDP Port Issue**: Railway primarily supports TCP. GMod uses UDP for game traffic. You may need to:
  - Use Railway's TCP proxy (may have higher latency)
  - Consider using a different hosting provider that supports UDP
  - Use a VPS with Docker instead

### Server crashes or restarts

- Check Railway resource limits
- Monitor memory usage (GMod servers can use 1-2GB RAM)
- Review server logs in Railway dashboard

### Workshop content not downloading

- Verify your Steam API key is valid
- Ensure the workshop collection is public
- Check that collection ID is correct
- Note: Large collections increase startup time significantly

## 💰 Railway Pricing

Railway is **not free** for always-on services:

- **Starter Plan**: $5/month + usage
- **Resource Usage**: Charged per hour based on CPU/RAM
- **Estimate**: A GMod server typically costs $10-20/month

Monitor your usage in the Railway dashboard.

## 🔒 Security

- **Change RCON password** in `server.cfg`
- Don't commit `.env` files with secrets
- Use Railway's environment variables for sensitive data
- Keep your Steam API key private

## 📚 Additional Resources

- [DarkRP Documentation](https://darkrp.miraheze.org/wiki/Main_Page)
- [Garry's Mod Wiki](https://wiki.facepunch.com/gmod/)
- [Railway Documentation](https://docs.railway.app/)
- [SteamCMD Wiki](https://developer.valvesoftware.com/wiki/SteamCMD)

## 📝 License

This is a configuration repository for running a Garry's Mod server. Garry's Mod and DarkRP have their own respective licenses.

## 🤝 Contributing

Feel free to submit issues or pull requests to improve this setup!

---

**Note**: This setup is designed for Railway deployment. For production servers with many players, consider using a VPS or dedicated server with full UDP support.
