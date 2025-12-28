# Garry's Mod DarkRP Server - Render.com Deployment Guide

## 🚀 Quick Deploy to Render

Your GMod DarkRP server is ready to deploy on Render.com!

### Step 1: Create Render Account

1. Go to [render.com](https://render.com)
2. Sign up with your GitHub account (recommended)

### Step 2: Deploy from GitHub

1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub account if not already connected
3. Select repository: **`zpx9ybf6hg-lang/gmodserver`**
4. Render will automatically detect the `render.yaml` configuration

### Step 3: Configure Settings

Render will auto-configure from `render.yaml`, but verify:

- **Name**: `gmod-darkrp-server`
- **Environment**: `Docker`
- **Plan**: `Starter` ($7/month) or `Free` (with limitations)
- **Region**: Choose closest to your players

### Step 4: Environment Variables

These are pre-configured in `render.yaml`, but you can customize:

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `GMOD_HOSTNAME` | `My DarkRP Server on Render` | Server name |
| `GMOD_MAP` | `rp_downtown_v4c_v2` | Starting map |
| `GMOD_MAXPLAYERS` | `16` | Max players |
| `GMOD_GAMEMODE` | `darkrp` | Gamemode |

### Step 5: Deploy!

1. Click **"Create Web Service"**
2. Render will build your Docker image (takes 5-10 minutes first time)
3. Wait for deployment to complete

### Step 6: Get Your Server Address

1. Once deployed, go to your service dashboard
2. Copy the URL (e.g., `gmod-darkrp-server.onrender.com`)
3. Note the port assigned by Render

### Step 7: Connect from Garry's Mod

Open console in GMod (`` ` `` key):
```
connect your-service.onrender.com:PORT
```

---

## ⚙️ Customization

### Change Server Settings

Edit environment variables in Render dashboard:
1. Go to your service
2. Click **"Environment"** tab
3. Modify variables
4. Service will auto-redeploy

### Add Workshop Content

1. Get Steam API key: https://steamcommunity.com/dev/apikey
2. Create a Workshop collection
3. Add these environment variables in Render:
   - `GMOD_WORKSHOP_API_KEY` = Your API key
   - `GMOD_WORKSHOP_COLLECTION` = Collection ID

### Change Map

Popular DarkRP maps:
- `rp_downtown_v4c_v2` (default)
- `rp_rockford_v2b`
- `rp_evocity_v4b1`
- `rp_florida_v2`

Change via `GMOD_MAP` environment variable.

---

## 💰 Render Pricing

### Free Plan
- ✅ 750 hours/month
- ⚠️ Spins down after 15 min of inactivity
- ⚠️ 512 MB RAM (may not be enough for GMod)
- ❌ Not suitable for public server

### Starter Plan ($7/month)
- ✅ Always on
- ✅ 512 MB RAM
- ⚠️ May struggle with many players
- ✅ Good for small servers (4-8 players)

### Standard Plan ($25/month)
- ✅ 2 GB RAM
- ✅ Better performance
- ✅ Good for 16+ players

---

## ⚠️ Important Limitations

### UDP Port Issue

> **WARNING**: Render primarily supports TCP connections. Garry's Mod uses UDP for game traffic.

**Potential issues:**
- Higher latency
- Connection problems
- Players may not be able to join

**Solutions:**
1. Test with friends first
2. If UDP issues occur, consider:
   - Using a VPS instead (Hetzner, DigitalOcean)
   - Using a game hosting service
   - Trying Railway (similar to Render)

### Performance

- Free tier may not have enough RAM
- Starter plan good for small groups
- For public servers, use Standard plan or VPS

---

## 🔧 Troubleshooting

### Server won't start
- Check Render logs in dashboard
- Verify Dockerfile built successfully
- Ensure environment variables are set

### Can't connect to server
- **UDP Issue**: Render may not support UDP properly
- Try using Render's TCP proxy
- Consider switching to VPS if problems persist

### Server crashes
- Upgrade to higher plan (more RAM)
- Check logs for errors
- Reduce max players

### Workshop content not loading
- Verify Steam API key is correct
- Ensure collection is public
- Check collection ID is correct

---

## 🔄 Auto-Deploy from GitHub

Render automatically deploys when you push to GitHub:

1. Make changes to your code locally
2. Commit and push:
   ```bash
   git add .
   git commit -m "Update server config"
   git push origin main
   ```
3. Render automatically rebuilds and deploys! 🎉

---

## 🔒 Security

**⚠️ IMPORTANT**: Change RCON password!

Edit `server.cfg` and change:
```
rcon_password "changeme123"  // Change this!
```

Then push to GitHub to update.

---

## 📊 Monitoring

In Render dashboard:
- **Logs**: View server console output
- **Metrics**: CPU, RAM usage
- **Events**: Deployment history

---

## 🆚 Render vs Railway

| Feature | Render | Railway |
|---------|--------|---------|
| Free tier | ✅ 750h/month | ❌ No free tier |
| Pricing | From $7/month | From $5/month |
| UDP support | ⚠️ Limited | ⚠️ Limited |
| Auto-deploy | ✅ Yes | ✅ Yes |
| Ease of use | ✅ Very easy | ✅ Very easy |

---

## 🎮 Alternative: VPS Recommendation

If you experience UDP issues on Render, I recommend:

**Hetzner VPS** (€4.5/month):
- ✅ Full UDP support
- ✅ Better performance
- ✅ More control
- ✅ Cheaper long-term

I can help you set up GitHub Actions to auto-deploy to a VPS if needed!

---

## 📚 Resources

- [Render Documentation](https://render.com/docs)
- [DarkRP Wiki](https://darkrp.miraheze.org/wiki/Main_Page)
- [GMod Server Setup](https://wiki.facepunch.com/gmod/Creating_A_Server)

---

**Your server is ready to deploy to Render! 🚀**

Need help? Let me know if you encounter any issues!
