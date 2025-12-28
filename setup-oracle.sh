#!/bin/bash

# Oracle Cloud GMod Server Setup Script
# This script sets up your Oracle Cloud VM for the GMod server

set -e

echo "========================================="
echo "  GMod DarkRP Server - Oracle Cloud Setup"
echo "========================================="
echo ""

# Update system
echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "✅ Docker installed"
else
    echo "✅ Docker already installed"
fi

# Install Docker Compose
echo "🐳 Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose installed"
else
    echo "✅ Docker Compose already installed"
fi

# Install Git
echo "📚 Installing Git..."
if ! command -v git &> /dev/null; then
    sudo apt-get install -y git
    echo "✅ Git installed"
else
    echo "✅ Git already installed"
fi

# Clone repository
echo "📥 Cloning GMod server repository..."
if [ ! -d "$HOME/gmodserver" ]; then
    git clone https://github.com/zpx9ybf6hg-lang/gmodserver.git $HOME/gmodserver
    echo "✅ Repository cloned"
else
    echo "✅ Repository already exists"
    cd $HOME/gmodserver
    git pull origin main
fi

# Configure firewall
echo "🔥 Configuring firewall..."
sudo iptables -I INPUT 6 -m state --state NEW -p udp --dport 27015 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 27015 -j ACCEPT
sudo netfilter-persistent save || echo "⚠️  Install iptables-persistent to persist firewall rules"

echo ""
echo "========================================="
echo "  ✅ Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Configure your server settings in .env file"
echo "2. Start the server: cd ~/gmodserver && docker-compose up -d"
echo "3. View logs: docker-compose logs -f"
echo ""
echo "Your server will be accessible at: YOUR_ORACLE_IP:27015"
echo ""
echo "⚠️  Don't forget to:"
echo "   - Open port 27015 (UDP/TCP) in Oracle Cloud Security List"
echo "   - Change RCON password in server.cfg"
echo ""
