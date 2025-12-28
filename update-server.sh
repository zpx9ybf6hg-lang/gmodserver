#!/bin/bash

# GMod Server Update Script (for GitHub Actions)
# This script updates the server when code is pushed to GitHub

set -e

echo "========================================="
echo "  Updating GMod Server"
echo "========================================="

cd /home/steam/gmodserver

# Pull latest changes
echo "📥 Pulling latest changes from GitHub..."
git pull origin main

# Update server files
echo "🔄 Updating GMod server files..."
/home/steam/steamcmd/steamcmd.sh \
    +force_install_dir /home/steam/gmodserver \
    +login anonymous \
    +app_update 4020 validate \
    +quit

# Copy updated config files
echo "📄 Copying configuration files..."
cp server.cfg garrysmod/cfg/server.cfg

# Copy custom config files
if [ -d "gmod-config/darkrp" ]; then
    cp -r gmod-config/darkrp/* garrysmod/gamemodes/darkrp/gamemode/config/ 2>/dev/null || true
fi
if [ -d "gmod-config/addons" ]; then
    cp -r gmod-config/addons/* garrysmod/addons/ 2>/dev/null || true
fi
if [ -d "gmod-config/lua" ]; then
    cp -r gmod-config/lua/* garrysmod/lua/ 2>/dev/null || true
fi
if [ -d "gmod-config/cfg" ]; then
    cp -r gmod-config/cfg/* garrysmod/cfg/ 2>/dev/null || true
fi

# Restart server
echo "🔄 Restarting server..."
sudo systemctl restart gmod-server

echo "✅ Update complete!"
echo "View logs: sudo journalctl -u gmod-server -f"
