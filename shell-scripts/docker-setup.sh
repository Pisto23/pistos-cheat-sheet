#!/bin/zsh

# Define password for sudo authentication and authenticate with sudo right away

if [ -z "$PASSWORD_FILE" ]; then
    echo "Error: PASSWORD_FILE environment variable is not set."
    exit 1
fi

password=$(<"$PASSWORD_FILE")

echo "$password" | sudo -S apt update 

# Debugging
set -x

# Create Docker group
sudo groupadd docker

# Add your user to the docker group
sudo usermod -aG docker $USER

# Activater the changes to the group
# sudo newgrp docker

# Add Docker's official GPG key:
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# Install latest Version
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Verify that docker is correct installed and working without sudo
docker run hello-world

# Remove hello-world image afterward to keep it clean
docker image rm hello-world --force