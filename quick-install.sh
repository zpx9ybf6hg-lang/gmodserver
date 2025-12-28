#!/bin/bash

# GMod Server Quick Install - Одна команда для установки всего!

set -e

echo "========================================="
echo "  🎮 GMod DarkRP Server - Quick Install"
echo "========================================="
echo ""

# Обновление системы
echo "📦 Обновление системы..."
sudo apt-get update -qq

# Установка зависимостей
echo "📦 Установка зависимостей..."
sudo dpkg --add-architecture i386
sudo apt-get update -qq
sudo apt-get install -y -qq \
    lib32gcc-s1 \
    lib32stdc++6 \
    wget \
    curl \
    tar \
    unzip \
    screen \
    ca-certificates

# Создание директорий
echo "📁 Создание директорий..."
mkdir -p ~/steamcmd ~/gmodserver

# Установка SteamCMD
echo "📥 Установка SteamCMD..."
cd ~/steamcmd
wget -q https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzf steamcmd_linux.tar.gz
rm steamcmd_linux.tar.gz

# Установка GMod сервера
echo "🎮 Установка GMod сервера (~6GB, 5-10 минут)..."
echo "Пожалуйста, подождите..."
~/steamcmd/steamcmd.sh +force_install_dir ~/gmodserver +login anonymous +app_update 4020 validate +quit

# Установка DarkRP
echo "📥 Установка DarkRP..."
cd ~/gmodserver/garrysmod/gamemodes
wget -q -O darkrp.zip https://github.com/FPtje/DarkRP/archive/refs/heads/master.zip
unzip -q darkrp.zip
mv DarkRP-master darkrp
rm darkrp.zip

# Создание server.cfg
echo "📄 Создание конфигурации..."
cat > ~/gmodserver/garrysmod/cfg/server.cfg <<'EOF'
hostname "My Awesome DarkRP Server"
rcon_password "changeme123"
sv_password ""
sv_lan 0

// DarkRP оптимизация
sbox_maxprops 150
sbox_godmode 0
sbox_noclip 0

// Сеть
sv_minrate 75000
sv_maxrate 0

log on
EOF

# Настройка firewall
echo "🔥 Настройка firewall..."
sudo iptables -I INPUT -p udp --dport 27015 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 27015 -j ACCEPT

echo ""
echo "========================================="
echo "  ✅ Установка завершена!"
echo "========================================="
echo ""
echo "Запустите сервер:"
echo "  screen -S gmod"
echo "  cd ~/gmodserver"
echo "  ./srcds_run -game garrysmod +maxplayers 16 +map rp_downtown_v4c_v2 +gamemode darkrp"
echo ""
echo "Адрес сервера: $(curl -s ifconfig.me):27015"
echo ""
echo "Для выхода из screen: Ctrl+A, потом D"
echo "Для возврата: screen -r gmod"
echo ""
