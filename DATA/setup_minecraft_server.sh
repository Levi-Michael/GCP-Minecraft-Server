#!/bin/bash

# Minecraft Server Setup Script

# Variables
MINECRAFT_USER="minecraft"
MINECRAFT_DIR="/home/$MINECRAFT_USER/server"
SERVER_JAR_URL="https://piston-data.mojang.com/v1/objects/4707d00eb834b446575d89a61a11b5d548d8c001/server.jar"
SERVER_JAR="server.jar"
JAVA_RAM="2G"

# Update and install dependencies
echo "Updating system and installing dependencies..."
sudo apt-get update && sudo apt-get upgrade -y

# Check for OpenJDK 21 availability
if apt-cache show openjdk-21-jdk-headless > /dev/null 2>&1; then
    sudo apt-get install openjdk-21-jdk-headless wget screen ufw -y
else
    echo "OpenJDK 21 not available, installing OpenJDK 17..."
    sudo apt-get install openjdk-17-jdk-headless wget screen ufw -y
fi

# Create a Minecraft user
echo "Creating dedicated Minecraft user..."
sudo adduser --system --home /home/$MINECRAFT_USER --shell /bin/bash $MINECRAFT_USER

# Set up the Minecraft server directory
echo "Setting up Minecraft server directory..."
sudo -u $MINECRAFT_USER mkdir -p $MINECRAFT_DIR
cd $MINECRAFT_DIR

# Download the Minecraft server JAR file
echo "Downloading Minecraft server JAR..."
sudo -u $MINECRAFT_USER wget $SERVER_JAR_URL -O $SERVER_JAR

# Accept the EULA
echo "Accepting EULA..."
echo "eula=true" | sudo -u $MINECRAFT_USER tee $MINECRAFT_DIR/eula.txt

# Run the server to generate initial files
echo "Running the server to generate files..."
sudo -u $MINECRAFT_USER java -Xmx${JAVA_RAM} -Xms${JAVA_RAM} -jar $SERVER_JAR nogui || true

# Configure UFW (firewall) for Minecraft
echo "Configuring UFW to allow Minecraft traffic..."
sudo ufw allow 25565/tcp
sudo ufw allow 22/tcp
sudo ufw enable

# Create a systemd service for the Minecraft server
echo "Creating systemd service..."
echo "[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=$MINECRAFT_USER
WorkingDirectory=$MINECRAFT_DIR
ExecStart=/usr/bin/java -Xmx${JAVA_RAM} -Xms${JAVA_RAM} -jar $SERVER_JAR nogui
Restart=always
RestartSec=10
Type=simple

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/minecraft.service

# Reload systemd and enable the service
echo "Enabling Minecraft service..."
sudo systemctl daemon-reload
sudo systemctl enable minecraft
sudo systemctl start minecraft

# Finish
echo "Minecraft server setup is complete!"
echo "You can manage the server using systemctl commands:"
echo "  sudo systemctl start minecraft"
echo "  sudo systemctl stop minecraft"
echo "  sudo systemctl restart minecraft"
echo "Server files are located in: $MINECRAFT_DIR"
