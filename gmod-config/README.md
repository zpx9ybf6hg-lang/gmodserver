# GMod Server Configuration Files

This directory contains all customizable GMod server files that will be automatically deployed to the server.

## 📁 Directory Structure

```
gmod-config/
├── darkrp/          # DarkRP configuration files (jobs, shipments, etc.)
├── addons/          # Custom addons (if not using Workshop)
├── lua/autorun/     # Auto-run Lua scripts
└── cfg/             # Additional .cfg files
```

## 🔧 How to Use

### 1. Edit Files Locally

Edit any configuration files in this directory on your computer.

### 2. Push to GitHub

```bash
git add gmod-config/
git commit -m "Update server config"
git push origin main
```

### 3. Automatic Deployment

GitHub Actions will automatically:
- Copy files to the server
- Restart the server
- Apply your changes

## 📝 Common Files to Customize

### DarkRP Configuration

Place DarkRP config files in `darkrp/`:
- `darkrp_config.lua` - Main DarkRP settings
- `darkrp_customthings.lua` - Jobs, shipments, entities
- `disabled_defaults.lua` - Disable default jobs/items

### Custom Addons

Place addon folders in `addons/`:
```
addons/
└── my_custom_addon/
    ├── lua/
    ├── materials/
    └── addon.json
```

### Lua Scripts

Place auto-run scripts in `lua/autorun/`:
- `server/` - Server-side scripts
- `client/` - Client-side scripts
- `shared/` - Shared scripts

### Server Config

Place additional .cfg files in `cfg/`:
- `autoexec.cfg` - Runs on server start
- `banned_user.cfg` - Banned users
- `banned_ip.cfg` - Banned IPs

## 🚀 Example: Adding a Custom Job

1. Create `gmod-config/darkrp/jobs.lua`:
```lua
TEAM_POLICE = DarkRP.createJob("Police Officer", {
    color = Color(25, 25, 170),
    model = {"models/player/police.mdl"},
    description = [[Protect the city]],
    weapons = {"weapon_glock2"},
    command = "police",
    max = 4,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = true,
})
```

2. Push to GitHub:
```bash
git add gmod-config/darkrp/jobs.lua
git commit -m "Add custom police job"
git push origin main
```

3. Server automatically updates! ✅

## ⚠️ Important Notes

- **DarkRP files** will be copied to `garrysmod/gamemodes/darkrp/gamemode/config/`
- **Addons** will be copied to `garrysmod/addons/`
- **Lua scripts** will be copied to `garrysmod/lua/autorun/`
- **Server restarts** automatically after deployment

## 📚 Resources

- [DarkRP Documentation](https://darkrp.miraheze.org/wiki/Main_Page)
- [GMod Lua Reference](https://wiki.facepunch.com/gmod/)
- [DarkRP Custom Jobs Guide](https://darkrp.miraheze.org/wiki/DarkRP:CustomJobsTutorial)
