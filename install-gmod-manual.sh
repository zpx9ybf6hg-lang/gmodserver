#!/bin/bash

# Manual GMod Server Installation
# Run this as the steam user

echo "========================================="
echo "  Installing GMod Server Manually"
echo "========================================="

cd /home/steam/steamcmd

# Run SteamCMD interactively
./steamcmd.sh <<EOF
force_install_dir /home/steam/gmodserver
login anonymous
app_update 4020 validate
quit
EOF

echo ""
echo "Installation complete!"
echo "Check /home/steam/gmodserver for files"
