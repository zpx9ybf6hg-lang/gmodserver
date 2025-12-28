#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Garry's Mod DarkRP Server Startup${NC}"
echo -e "${GREEN}========================================${NC}"

# Set default values
HOSTNAME="${GMOD_HOSTNAME:-Garrys Mod DarkRP Server}"
MAP="${GMOD_MAP:-rp_downtown_v4c_v2}"
MAXPLAYERS="${GMOD_MAXPLAYERS:-16}"
GAMEMODE="${GMOD_GAMEMODE:-darkrp}"
PORT="${PORT:-27015}"
WORKSHOP_COLLECTION="${GMOD_WORKSHOP_COLLECTION:-}"
WORKSHOP_API_KEY="${GMOD_WORKSHOP_API_KEY:-}"

echo -e "${YELLOW}Server Configuration:${NC}"
echo "  Hostname: $HOSTNAME"
echo "  Map: $MAP"
echo "  Max Players: $MAXPLAYERS"
echo "  Gamemode: $GAMEMODE"
echo "  Port: $PORT"

# Update server files
echo -e "${YELLOW}Updating server files...${NC}"
/home/steam/steamcmd/steamcmd.sh \
    +force_install_dir /home/steam/gmodserver \
    +login anonymous \
    +app_update 4020 validate \
    +quit

# Install DarkRP
if [ ! -d "/home/steam/gmodserver/garrysmod/gamemodes/darkrp" ]; then
    echo -e "${YELLOW}Installing DarkRP...${NC}"
    cd /home/steam/gmodserver/garrysmod/gamemodes
    wget -O darkrp.zip https://github.com/FPtje/DarkRP/archive/refs/heads/master.zip
    unzip -q darkrp.zip
    mv DarkRP-master darkrp
    rm darkrp.zip
    echo -e "${GREEN}DarkRP installed successfully!${NC}"
else
    echo -e "${GREEN}DarkRP already installed.${NC}"
fi

# Copy custom config files
echo -e "${YELLOW}Copying custom configuration files...${NC}"
cd /home/steam/gmodserver

if [ -d "/home/steam/gmod-config/darkrp" ]; then
    cp -r /home/steam/gmod-config/darkrp/* garrysmod/gamemodes/darkrp/gamemode/config/ 2>/dev/null || true
    echo -e "${GREEN}DarkRP config copied${NC}"
fi

if [ -d "/home/steam/gmod-config/addons" ]; then
    cp -r /home/steam/gmod-config/addons/* garrysmod/addons/ 2>/dev/null || true
    echo -e "${GREEN}Addons copied${NC}"
fi

if [ -d "/home/steam/gmod-config/lua" ]; then
    cp -r /home/steam/gmod-config/lua/* garrysmod/lua/ 2>/dev/null || true
    echo -e "${GREEN}Lua scripts copied${NC}"
fi

if [ -d "/home/steam/gmod-config/cfg" ]; then
    cp -r /home/steam/gmod-config/cfg/* garrysmod/cfg/ 2>/dev/null || true
    echo -e "${GREEN}Config files copied${NC}"
fi

# Workshop params
WORKSHOP_PARAMS=""
if [ ! -z "$WORKSHOP_COLLECTION" ] && [ ! -z "$WORKSHOP_API_KEY" ]; then
    echo -e "${YELLOW}Workshop collection: $WORKSHOP_COLLECTION${NC}"
    WORKSHOP_PARAMS="+host_workshop_collection $WORKSHOP_COLLECTION -authkey $WORKSHOP_API_KEY"
fi

# Start server
echo -e "${GREEN}Starting Garry's Mod Server...${NC}"
echo -e "${GREEN}========================================${NC}"

cd /home/steam/gmodserver

./srcds_run -game garrysmod -console -norestart +maxplayers $MAXPLAYERS +hostname "$HOSTNAME" +map $MAP +gamemode $GAMEMODE -port $PORT $WORKSHOP_PARAMS
