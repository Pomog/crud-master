#!/usr/bin/env bash

set -e

# Load environment variables
if [ -f /vagrant/.env ]; then
  export $(grep -v '^#' /vagrant/.env | xargs)
fi

echo "[BILLING-SETUP] Updating apt packages..."
sudo apt-get update -y

echo "[BILLING-SETUP] Installing Node.js & npm..."
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "[BILLING-SETUP] Installing PM2 globally..."
sudo npm install -g pm2

echo "[BILLING-SETUP] Installing PostgreSQL..."
sudo apt-get install -y postgresql postgresql-contrib

echo "[BILLING-SETUP] Creating orders database..."
sudo -u postgres psql -c "CREATE DATABASE ${ORDERS_DB};" || true
# If needed, create user & grant privileges similarly to Inventory.

echo "[BILLING-SETUP] Installing RabbitMQ..."
sudo apt-get install -y rabbitmq-server

echo "[BILLING-SETUP] Enabling and starting RabbitMQ service..."
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server

# Optionally configure RabbitMQ user if not using the default "guest"/"guest"
# e.g.:
# sudo rabbitmqctl add_user $RABBITMQ_USER $RABBITMQ_PASS
# sudo rabbitmqctl set_permissions -p / $RABBITMQ_USER ".*" ".*" ".*"

# Copy the billing app from the shared folder
echo "[BILLING-SETUP] Setting up Billing app..."
mkdir -p /home/vagrant/billing-app
cp -r /vagrant/srcs/billing-app/* /home/vagrant/billing-app/
cd /home/vagrant/billing-app

echo "[BILLING-SETUP] Installing app dependencies..."
npm install

# (Optional) Sync/Initialize DB table if code is set up for it.

echo "[BILLING-SETUP] Starting Billing app with PM2..."
pm2 start server.js --name billing_app

# Configure PM2 to run at startup
pm2 startup systemd
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u vagrant --hp /home/vagrant
pm2 save

echo "[BILLING-SETUP] Billing setup complete."