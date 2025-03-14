#!/bin/bash

# Install Composer dependencies
echo "Running Composer install..."
./scripts/composer_wrapper.php install

# Define the username variable
USERNAME="librenms"

# Grant the librenms user sudo privileges
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USERNAME > /dev/null
sudo chmod 0440 /etc/sudoers.d/$USERNAME

# Get the group ID of vscode user
VSCODE_GROUP=$(id -g vscode)

# Add librenms user to the same group as vscode
sudo usermod -aG "$VSCODE_GROUP" "$USERNAME"

# Set group ownership for LibreNMS directories
echo "Setting group ownership for LibreNMS..."
sudo chown -R :"$VSCODE_GROUP" /opt/librenms

# Set permissions for LibreNMS directories for the group
echo "Setting permissions for LibreNMS..."
sudo chmod -R g+rwx /opt/librenms

# Set directory permissions for LibreNMS with proper group access
sudo chmod 770 /opt/librenms

# Set ACL to ensure the group has the right permissions on subdirectories
echo "Setting ACL for group permissions on LibreNMS directories..."
sudo setfacl -d -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/
sudo setfacl -R -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/

# Start MariaDB service
sudo service mariadb start

# Wait for MariaDB to be ready
until sudo mysqladmin ping -h"localhost" --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 1
done
echo "MariaDB is ready!"

# MariaDB Setup: Create Database & User
echo "Creating MariaDB database and user..."
sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS librenms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -u root -e "CREATE USER IF NOT EXISTS 'librenms'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON librenms.* TO 'librenms'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

# Wait for MariaDB to initialize and be ready
sleep 5

echo "MariaDB setup complete."

# Start the development web server for LibreNMS
echo "If you want to start the development server, use the following command:"
echo "./lnms serve"
echo "Development server will start at http://localhost:8000"
echo "Setup complete."