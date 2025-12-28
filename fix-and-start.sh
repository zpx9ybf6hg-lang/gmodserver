#!/bin/bash

# GMod Server Quick Fix Script
# This script will fix all issues and start the server

set -e

echo "========================================="
echo "  GMod Server Quick Fix & Start"
echo "========================================="
echo ""

# Navigate to project directory
cd ~/gmodserver

echo "✅ Step 1: Stopping any running containers..."
docker-compose down 2>/dev/null || true

echo "✅ Step 2: Cleaning up old Docker images..."
docker rmi gmodserver-gmod-server:latest 2>/dev/null || true
docker system prune -f

echo "✅ Step 3: Pulling latest code from GitHub..."
git pull origin main

echo "✅ Step 4: Fixing line endings in start.sh..."
sed -i 's/\r$//' start.sh

echo "✅ Step 5: Ensuring .env file exists..."
if [ ! -f .env ]; then
    cp .env.oracle .env
    echo "Created .env file"
fi

echo "✅ Step 6: Building Docker image (this may take a few minutes)..."
docker-compose build --no-cache --pull

echo "✅ Step 7: Starting the server..."
docker-compose up -d

echo ""
echo "========================================="
echo "  ✅ Server is starting!"
echo "========================================="
echo ""
echo "View logs with: docker-compose logs -f"
echo "Your server IP: 152.70.18.104:27015"
echo ""
echo "The server will download GMod (~4GB) on first start."
echo "This will take 5-10 minutes. Be patient!"
echo ""
