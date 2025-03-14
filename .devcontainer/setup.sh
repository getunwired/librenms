#!/bin/bash

# Define the username variable
USERNAME="librenms"

# Grant the librenms user sudo privileges
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USERNAME > /dev/null
sudo chmod 0440 /etc/sudoers.d/$USERNAME

# Set group ownership for LibreNMS directories
echo "Setting group ownership for LibreNMS..."
chown -R "$USERNAME":"$USERNAME" /opt/librenms

# Set directory permissions for LibreNMS with proper group access
chmod 771 /opt/librenms

# Set ACL to ensure the group has the right permissions on subdirectories
echo "Setting ACL for group permissions on LibreNMS directories..."
sudo setfacl -d -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/
sudo setfacl -R -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/

# Install Composer dependencies
echo "Running Composer install..."
./scripts/composer_wrapper.php install

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