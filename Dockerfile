FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    lib32gcc-s1 \
    lib32stdc++6 \
    wget \
    curl \
    tar \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create steam user and directories
RUN useradd -m -d /home/steam steam && \
    mkdir -p /home/steam/steamcmd /home/steam/gmodserver

# Set working directory
WORKDIR /home/steam

# Download and extract SteamCMD
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz -C /home/steam/steamcmd && \
    rm steamcmd_linux.tar.gz

# Change ownership
RUN chown -R steam:steam /home/steam

# Switch to steam user
USER steam

# Install Garry's Mod Dedicated Server
RUN /home/steam/steamcmd/steamcmd.sh \
    +force_install_dir /home/steam/gmodserver \
    +login anonymous \
    +app_update 4020 validate \
    +quit

# Copy server configuration files
COPY --chown=steam:steam server.cfg /home/steam/gmodserver/garrysmod/cfg/server.cfg
COPY --chown=steam:steam start.sh /home/steam/start.sh

# Make start script executable
RUN chmod +x /home/steam/start.sh

# Set working directory to server
WORKDIR /home/steam/gmodserver

# Expose ports (Railway will map these)
# 27015 is the default GMod port (UDP for game, TCP for RCON)
EXPOSE 27015/udp 27015/tcp

# Start the server
CMD ["/home/steam/start.sh"]
