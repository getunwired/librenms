#!/bin/bash

# Start MySQL service
sudo service mysql start

# Wait for MySQL to be ready
until sudo mysqladmin ping -h"localhost" --silent; do
    echo "Waiting for MySQL to be ready..."
    sleep 1
done
echo "MySQL is ready!"

# MySQL Setup: Create Database & User
echo "Creating MySQL database and user..."
sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS librenms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -u root -e "CREATE USER IF NOT EXISTS 'librenms'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON librenms.* TO 'librenms'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

# Wait for MySQL to initialize and be ready
sleep 5

echo "MySQL setup complete."

# Install Composer dependencies
echo "Running Composer install..."
./scripts/composer_wrapper.php install

# Set permissions for LibreNMS directories
echo "Setting permissions for LibreNMS..."
sudo chown -R librenms:librenms /opt/librenms
sudo chmod 771 /opt/librenms
sudo setfacl -d -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/
sudo setfacl -R -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/

# Start the development web server
echo "If you want to start the development server, use the following command:"
echo "  ./lnms serve"

echo "Development server started at http://localhost:8000"