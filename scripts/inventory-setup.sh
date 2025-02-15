#!/usr/bin/env bash

set -e

# Load environment variables
if [ -f /vagrant/.env ]; then
  export $(grep -v '^#' /vagrant/.env | xargs)
fi

echo "[INVENTORY-SETUP] Updating apt packages..."
sudo apt-get update -y

echo "[INVENTORY-SETUP] Installing Node.js & npm..."
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "[INVENTORY-SETUP] Installing PM2 globally..."
sudo npm install -g pm2

echo "[INVENTORY-SETUP] Installing PostgreSQL..."
sudo apt-get install -y postgresql postgresql-contrib

# Set up PostgreSQL for the Inventory DB
echo "[INVENTORY-SETUP] Creating movies database..."
sudo -u postgres psql -c "CREATE DATABASE ${MOVIES_DB};" || true
# Optionally create a dedicated DB user if needed (and adjust code accordingly)
# e.g.: sudo -u postgres psql -c "CREATE USER ${POSTGRES_USER} WITH PASSWORD '${POSTGRES_PASSWORD}';"

# Grant privileges if you created a new user
# e.g.: sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${MOVIES_DB} TO ${POSTGRES_USER};"

# Copy the inventory app from the shared folder
echo "[INVENTORY-SETUP] Setting up Inventory app..."
mkdir -p /home/vagrant/inventory-app
cp -r /vagrant/srcs/inventory-app/* /home/vagrant/inventory-app/
cd /home/vagrant/inventory-app

echo "[INVENTORY-SETUP] Installing app dependencies..."
npm install

# (Optional) Sync/Initialize DB table directly from the app if code is set up for it
# For example, if server.js or a dedicated script auto-creates the table using Sequelize's sync().

echo "[INVENTORY-SETUP] Starting Inventory app with PM2..."
pm2 start server.js --name inventory_app

# Setup PM2 on VM boot
pm2 startup systemd
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u vagrant --hp /home/vagrant
pm2 save

echo "[INVENTORY-SETUP] Inventory setup complete."