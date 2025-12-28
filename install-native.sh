#!/bin/bash

# GMod Server Native Installation (No Docker)
# This script installs GMod server directly on Ubuntu

set -e

echo "========================================="
echo "  GMod Server Native Installation"
echo "========================================="
echo ""

# Update system
echo "📦 Updating system..."
sudo apt-get update

# Install dependencies
echo "📦 Installing dependencies..."
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y \
    lib32gcc-s1 \
    lib32stdc++6 \
    wget \
    curl \
    tar \
    unzip \
    git \
    screen \
    ca-certificates

# Create steam user if doesn't exist
if ! id -u steam >/dev/null 2>&1; then
    echo "👤 Creating steam user..."
    sudo useradd -m -s /bin/bash steam
fi

# Install SteamCMD
echo "📥 Installing SteamCMD..."
sudo -u steam mkdir -p /home/steam/steamcmd
cd /home/steam/steamcmd
sudo -u steam wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
sudo -u steam tar -xvzf steamcmd_linux.tar.gz
sudo -u steam rm steamcmd_linux.tar.gz

# Clone repository
echo "📥 Cloning GMod server repository..."
if [ -d "/home/steam/gmodserver" ]; then
    echo "Repository already exists, pulling latest changes..."
    cd /home/steam/gmodserver
    sudo -u steam git pull origin main
else
    cd /home/steam
    sudo -u steam git clone https://github.com/zpx9ybf6hg-lang/gmodserver.git
fi

# Create necessary directories
echo "📁 Creating directories..."
sudo -u steam mkdir -p /home/steam/gmodserver/garrysmod/cfg
sudo -u steam mkdir -p /home/steam/gmodserver/garrysmod/gamemodes
sudo -u steam mkdir -p /home/steam/gmodserver/garrysmod/addons
sudo -u steam mkdir -p /home/steam/gmodserver/garrysmod/lua/autorun/server

# Copy server.cfg
echo "📄 Copying server configuration..."
sudo -u steam cp /home/steam/gmodserver/server.cfg /home/steam/gmodserver/garrysmod/cfg/server.cfg

# Install GMod server
echo "🎮 Installing Garry's Mod Dedicated Server..."
echo "This will take 5-10 minutes..."
sudo -u steam /home/steam/steamcmd/steamcmd.sh \
    +force_install_dir /home/steam/gmodserver \
    +login anonymous \
    +app_update 4020 validate \
    +quit

# Install DarkRP
if [ ! -d "/home/steam/gmodserver/garrysmod/gamemodes/darkrp" ]; then
    echo "📥 Installing DarkRP..."
    cd /home/steam/gmodserver/garrysmod/gamemodes
    sudo -u steam wget -O darkrp.zip https://github.com/FPtje/DarkRP/archive/refs/heads/master.zip
    sudo -u steam unzip -q darkrp.zip
    sudo -u steam mv DarkRP-master darkrp
    sudo -u steam rm darkrp.zip
    echo "✅ DarkRP installed!"
fi

# Copy custom config files
echo "📄 Copying custom configuration files..."
if [ -d "/home/steam/gmodserver/gmod-config/darkrp" ]; then
    sudo -u steam cp -r /home/steam/gmodserver/gmod-config/darkrp/* /home/steam/gmodserver/garrysmod/gamemodes/darkrp/gamemode/config/ 2>/dev/null || true
fi
if [ -d "/home/steam/gmodserver/gmod-config/addons" ]; then
    sudo -u steam cp -r /home/steam/gmodserver/gmod-config/addons/* /home/steam/gmodserver/garrysmod/addons/ 2>/dev/null || true
fi
if [ -d "/home/steam/gmodserver/gmod-config/lua" ]; then
    sudo -u steam cp -r /home/steam/gmodserver/gmod-config/lua/* /home/steam/gmodserver/garrysmod/lua/ 2>/dev/null || true
fi
if [ -d "/home/steam/gmodserver/gmod-config/cfg" ]; then
    sudo -u steam cp -r /home/steam/gmodserver/gmod-config/cfg/* /home/steam/gmodserver/garrysmod/cfg/ 2>/dev/null || true
fi

# Create systemd service
echo "⚙️  Creating systemd service..."
sudo tee /etc/systemd/system/gmod-server.service > /dev/null <<EOF
[Unit]
Description=Garry's Mod DarkRP Server
After=network.target

[Service]
Type=simple
User=steam
WorkingDirectory=/home/steam/gmodserver
ExecStart=/home/steam/gmodserver/srcds_run -game garrysmod -console -norestart +maxplayers 16 +hostname "My Awesome DarkRP Server" +map rp_downtown_v4c_v2 +gamemode darkrp -port 27015
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reload

# Configure firewall
echo "🔥 Configuring firewall..."
sudo iptables -I INPUT -p udp --dport 27015 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 27015 -j ACCEPT

# Save iptables rules
sudo mkdir -p /etc/iptables
sudo iptables-save | sudo tee /etc/iptables/rules.v4 > /dev/null

echo ""
echo "========================================="
echo "  ✅ Installation Complete!"
echo "========================================="
echo ""
echo "To start the server:"
echo "  sudo systemctl start gmod-server"
echo ""
echo "To view logs:"
echo "  sudo journalctl -u gmod-server -f"
echo ""
echo "To enable auto-start on boot:"
echo "  sudo systemctl enable gmod-server"
echo ""
echo "Server IP: $(curl -s ifconfig.me):27015"
echo ""
