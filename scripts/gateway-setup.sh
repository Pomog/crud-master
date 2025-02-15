#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Optional: Source environment variables from /vagrant/.env
# If you're passing environment variables directly via Vagrant,
# you can skip this. Or if your .env has sensitive data, consider
# not cat-ing it outright.
if [ -f /vagrant/.env ]; then
  export $(grep -v '^#' /vagrant/.env | xargs)
fi

echo "[GATEWAY-SETUP] Updating apt packages..."
sudo apt-get update -y

echo "[GATEWAY-SETUP] Installing Node.js & npm..."
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "[GATEWAY-SETUP] Installing PM2 globally..."
sudo npm install -g pm2

# Optional: Copy or symlink your gateway code from the shared folder (/vagrant/srcs/).
# For example, if your gateway code is in /vagrant/srcs/api-gateway
echo "[GATEWAY-SETUP] Setting up API Gateway code..."
mkdir -p /home/vagrant/api-gateway
cp -r /vagrant/srcs/api-gateway/* /home/vagrant/api-gateway/
cd /home/vagrant/api-gateway

echo "[GATEWAY-SETUP] Installing Gateway dependencies..."
npm install

echo "[GATEWAY-SETUP] Starting Gateway with PM2..."
# Give the app a unique name in PM2, e.g., "gateway_app"
pm2 start server.js --name gateway_app

# (Optional) Configure PM2 to start on VM boot
pm2 startup systemd
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u vagrant --hp /home/vagrant
pm2 save

echo "[GATEWAY-SETUP] Gateway setup complete."