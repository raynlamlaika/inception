#!/bin/bash

# the set up of database mariadb for inception

# Check presence of mariadb server daemon and client tool
if ! command -v mariadbd &> /dev/null || ! command -v mariadb &> /dev/null; then
    echo "Error: MariaDB or mariadb-client is not installed. Aborting."
    echo "Install with: apt-get install mariadb-server mariadb-client"
    exit 1
fi

echo "MariaDB found! Continuing with the script..."


# Start the MariaDB service in the background
if ! service mariadb start; then
    echo "Error: Failed to start MariaDB service. Aborting."
    exit 1
fi

for i in {1..30}; do
    if mariadb -e "SELECT 1;" &> /dev/null; then
        echo "MariaDB is up and running!"
        break
    fi
    echo "Waiting for MariaDB to start... ($i/30)"
    sleep 1
done

if ! mariadb -u root -e "SELECT 1;" &> /dev/null; then
    echo "Error: MariaDB did not start within the expected time. Aborting."
    exit 1
fi

echo "Starting MariaDB service..."

if ! mariadb -u root -e "CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME;" &> /dev/null; then
    echo "Error: Failed to create database '$WORDPRESS_DB_NAME'. Aborting."
    exit 1
fi

if ! mariadb -u root -e "CREATE USER IF NOT EXISTS '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD';" &> /dev/null; then
    echo "Error: Failed to create user '$WORDPRESS_DB_USER'. Aborting."
    exit 1
fi

if ! mariadb -u root -e "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'%';" &> /dev/null; then
    echo "Error: Failed to grant privileges to user '$WORDPRESS_DB_USER'. Aborting."
    exit 1
fi

# Flush privileges to ensure that all changes take effect
if ! mariadb -u root -e "FLUSH PRIVILEGES;" &> /dev/null; then
    echo "Error: Failed to flush privileges. Aborting."
    exit 1
fi

echo "Database setup completed successfully!"