#!/bin/bash

# Start MariaDB temporarily for initialization
service mariadb start

# Wait until MariaDB is accepting connections (try without password first, then with)
until mysqladmin -u root ping >/dev/null 2>&1 || mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} ping >/dev/null 2>&1; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# Determine if root password is already set
if mysql -u root -e "SELECT 1;" >/dev/null 2>&1; then
    # Fresh install: root has no password yet — run setup
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
else
    # Re-run with password (volume already has a root password from a previous run)
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
fi

mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Start MariaDB in the foreground on all interfaces so other containers can reach it
echo "MariaDB is ready. Starting in foreground..."
exec mysqld_safe --bind-address=0.0.0.0